# IAC Ansible
Ansible is an IAC Configuration management tool
## How it works

## How to set it up
- We are setting up our controller machine in AWS. Ansible_bash.sh is a script that will install ansible & associated dependencies.
### Host file
- General syntax specifying how to connect to a host
```
[name of host]
<ip> ansible_connection=ssh ansible_ssh_private_key_file=/path/to/key
```
- A specific example
```
[host_a]
172.31.39.173 ansible_connection=ssh ansible_ssh_private_key_file=/home/ubuntu/.ssh/eng74-jamie-aws-key.pem
```
## Main sections

## Main commands
- Ping all hosts
`ansible all -m ping`
- Test the private IP
`ansible host_a -m ping`
- Test the public IP
`ansible host_b -m ping`
- update the source list in the host machine
`ansible host_b -a "sudo apt-get update"`
- Get systems information of host machines
`ansible all -a "uname -a"`
- Get the time taken to execute a command in the host machines
`ansible all -a "time"`
- Display current date and time in the host machines
`ansible all -a "date"`
- Running apt-get in an OS independant way (the --become flag uses whatever the
  correct privilege escalation command is in that environment e.g. sudo)
`ansible all -a "apt-get " --become`
- Check uptime of host machines
`ansible all -a "uptime"`
- Update and upgrade all packages in an adhoc way
`ansible all -m apt -a "upgrade=yes update_cache=yes cache_valid_time=86400" --become`
- Removing a folder
`ansible host_`

## Writing a Playbook
### Main Structure

## Writing a Task / How to Provision
### Packages
**Syntax for installing apt packages**
```YAML
- name: Installing a package (you can call this whatever you want)
  apt:
    name: <package>
    state: present
    update_cache: yes
```
- Where <package> is replaced by the name of the package e.g. name: git
**Syntax for installing multiple apt packages at once**
```YAML
- name: Intalling nginx and npm
  apt:
    pkg:
      - nginx
      - npm
    state: present
```
- or
```YAML
- name: Installing nginx and npm
  apt:
    package: ['nginx', 'npm']
    state: present`
```
**Syntax for installing npm packages**
- The most up to date method
```YAML
- name: Installing pm2
  community.general.npm
    name: pm2
    path: /location/to/install
```
- The path line can be replaced with global: yes as in the next example from an
older method of installing npm packages
```YAML
- name: Installing pm2
  npm:
    name: pm2
    global: yes
```
### Files
**How to create a file**
```YAML
- name: create file
  file:
    path: path/for/file.txt
    state: touch
    mode: permission_number
```
**How to write in files (e.g. for config files)**
```YAML
- name:
  blockinfile:
    path:
    block: |
      code goes here {
        it can do whatever you need
      }
```
**How to remove a file**
```YAML
- name: remove file
  file:
    path: /path/to/file.txt
    state: absent
```
**How to create a symbolic link**
```YAML
- name: create symbolic link between sites enabled and available
  file:
    src: /etc/nginx/sites-available/default.conf
    dest: /etc/nginx/sites-enabled/default.conf
    state: link
```
**How to secure copy across folders**
```YAML
- name: Copy app folder
  copy:
    src: /path/to/file
    dest: /destination/
    remote_src: yes
```
**How to online copy across folders**

**How to synchronise folders**
```YAML
- name: Sycning directory
  synchronize:
      src: /source/path
      dest: /destination/path
```
### Services and Handlers
**How to manage a service**
```YAML
- name: start and enable nginx
  service:
    name: nginx
    state: started
    enabled: yes
```
**Using handlers**
- Handlers run when called with a notify in a task
- Handlers should be placed indented to the same level as the `tasks:` declaration,
this can be after all the tasks have been defined
```YAML
 handlers:
   - name: Restart nginx
     service: nginx
     state: restarted
```
- This requires a task to use notify like in this modified example from earlier
```YAML
- name: create symbolic link between sites enabled and available
  file:
    src: /etc/nginx/sites-available/default.conf
    dest: /etc/nginx/sites-enabled/default.conf
    state: link
    notify: Restart nginx
```
### Running shell (bash) commands
**Running bash commands**
- become and become_user allow ansible to run the commands with escalated privileges
 and to specify the user to be used when executing it
```YAML
- name: Executing a shell command
  become: true
  become_user: ubuntu
  shell: shell commands to execute here
```
### Using Templates
- The template module can be used to accomplish polymorphism in our playbooks
- We can construct text files that hold all the configuration settings needed to
setup various systems with specifics replaced with {{variables}} to be determined
later
- When using the module we need src (source of template file) and dest (destination
  path)
- At execution time, the playbook replaces the variables in the template file
with the relevant values in the destination file
- Template files usually have a .j2 (jinja2) extension
- An example could be
```YAML
---  
- hosts: all  
  vars:  
    variable1: 'Hello'  
    variable2: 'My first playbook using template'  
  tasks:  
    - name: Basic Template Example  
      template:  
        src: example1.j2  
        dest: /home/knoldus/Documents/Ansible/output.txt  
```
- with the template file of
```
{{variable1}}  
No change in this line  
{{variable2}}  
```
- leading to this output
```
Hello
No change in this line
My first playbook using the template
```

## Configuring a server
