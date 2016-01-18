boxy-rails Cookbook
====================
Setup boxy-rails and monit recipies

Requirements
------------
See metadata


Attributes
----------
* ['monit']['username'] - username to access monit dashboard- defaults to 'monit'
* ['monit']['password'] - password to access monit dashboard- defaults to 'OYdBsmI3Zz5E7j1p2blg', configure as needed

See attributes for detailed attributes


Usage
-----
Just include `boxy-rails` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[boxy-rails]"
  ]
}
```

Dashboard
---------
* Default monit Dashboard is configured to run on http://machine_ip:3737 with user- monit and password- OYdBsmI3Zz5E7j1p2blg
 

Contributing
------------


1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Brought to you by
-----------------

[![BigBinary logo](http://bigbinary.com/assets/common/logo.png)](http://BigBinary.com)
