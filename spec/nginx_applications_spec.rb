require 'spec_helper'

describe 'boxy-rails::nginx_applications' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    stub_command('which nginx').and_return(true)
  end

  it 'generates correct nginx site configuration' do
    chef_run.node.set['boxy-rails'][:applications] = [
      { name: 'wheel', ssl: true, domain: 'wheel.com' },
      { name: 'drone' }
    ]
    chef_run.converge(described_recipe)

    expect(chef_run).to render_file(nginx_conf_file_path(chef_run, 'wheel')).with_content { |content|
      expect(content).to eq(read_fixture_file('wheel_nginx_conf'))
    }

    expect(chef_run).to render_file(nginx_conf_file_path(chef_run, 'drone')).with_content { |content|
      expect(content).to eq(read_fixture_file('drone_nginx_conf'))
    }
  end

  it 'supports extra locations' do
    chef_run.node.set['boxy-rails'][:applications] = [
      { name: 'wheel',
        ssl: true,
        domain: 'wheel.com',
        custom_locations: [
          {
            uri: '~ ^/somelocation',
            directives: {
              'proxy_http_version' => 1.1,
              'proxy_set_header' => ['Upgrade $http_upgrade', 'Connection $connection_upgrade'],
              'proxy_pass' =>  'http://localhost:8800'
            }
          },
          {
            uri: '/otheruri',
            directives: {
              'proxy_pass' => 'http://localhost:9219'
            }
          }
        ]
      }
    ]
    chef_run.converge(described_recipe)

    expect(chef_run).to render_file(nginx_conf_file_path(chef_run, 'wheel')).with_content { |content|
      expect(content).to eq(read_fixture_file('wheel_with_custom_locations_nginx_conf'))
    }
  end

  it 'supports extra upstreams' do
    chef_run.node.set['boxy-rails'][:applications] = [
      { name: 'wheel',
        ssl: true,
        domain: 'wheel.com',
        ssl_redirect: true,
        custom_upstreams: [
          {
            name: 'websocket',
            uri: 'localhost:8800'
          },
          {
            name: 'java-app',
            uri: 'localhost:9219'
          }
        ],
        custom_locations: [
          {
            uri: '~ ^/somelocation',
            directives: {
              'proxy_http_version' => 1.1,
              'proxy_set_header' => ['Upgrade $http_upgrade', 'Connection $connection_upgrade'],
              'proxy_pass' =>  'http://websocket'
            }
          },
          {
            uri: '/otheruri',
            directives: {
              'proxy_pass' => 'http://java-app'
            }
          }
        ]
      }
    ]
    chef_run.converge(described_recipe)

    expect(chef_run).to render_file(nginx_conf_file_path(chef_run, 'wheel')).with_content { |content|
      expect(content).to eq(read_fixture_file('wheel_with_custom_upstreams_nginx_conf'))
    }
  end

  def nginx_conf_file_path(chef_run, app_name)
    File.join(chef_run.node['nginx']['dir'], 'sites-available', app_name)
  end
end
