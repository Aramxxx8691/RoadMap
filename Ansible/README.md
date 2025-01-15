# Ansible Project: Deploy and Manage Web Servers

This project is designed to automate the deployment and management of Apache web servers on both Ubuntu and RedHat-based systems using **Ansible**. It covers a range of tasks, including creating files and directories, installing and configuring Apache, deploying a custom web page, and handling server-specific configurations.

## Project Structure
```
ansible/
├── ansible.cfg          # Configuration file for Ansible
├── create_file.yml      # Task to create files with dynamic content
├── create_folder.yml    # Task to create directories
├── group_vars           # Variables for server groups
│   ├── PROD_SERVERS_WEB
│   └── STAGING_SERVERS_WEB
├── hosts.txt            # Inventory file defining hosts and groups
├── playbook.yml         # Main playbook to execute roles and tasks
└── roles
    └── deploy_apache_web
        ├── README.md       # Role-specific documentation
        ├── defaults
        │   └── main.yml    # Default variables for the role
        ├── files
        │   └── style.css   # Static files for the web page
        ├── handlers
        │   └── main.yml    # Handlers to restart Apache
        ├── meta
        │   └── main.yml    # Metadata for the role
        ├── tasks
        │   └── main.yml    # Main tasks for deploying Apache
        ├── templates
        │   └── index.j2    # Template for the web page
        ├── tests
        │   ├── inventory   # Inventory for testing
        │   └── test.yml    # Test playbook
        └── vars
            └── main.yml    # Role-specific variables
```

## Key Configuration Files
### ansible.cfg
This file defines Ansible's global behavior. Key configurations include:

- `host_key_checking = false`: Disables strict checking of host keys, allowing smoother connections to servers.
- `inventory = ./hosts.txt`: Specifies the location of the inventory file (`hosts.txt`) containing server details.
- `interpreter_python = /usr/bin/python3.9`: Ensures Ansible uses Python 3.9 on the target machines.

### hosts.txt
The inventory file organizes your servers into groups for easier management. Here's a sample structure:
```
[STAGING_LINUX]
AWS_Linux1 ansible_host=172.31.43.161

[PROD_LINUX]
AWS_Linux ansible_host=172.31.46.177
AWS_Linux ansible_host=172.31.32.60

[PROD_UBUNTU]
AWS_Ubuntu ansible_host=172.31.42.70 ansible_user=ec2-user ansible_ssh_private_key_file=/home/ec2-user/.ssh/client2-frankfurt.pem
```

### Alternative: Dynamic Inventory for AWS
Ansible now includes a built-in plugin for managing AWS inventories dynamically, removing the need for the old ec2.py script.

Steps to Enable Dynamic Inventory:
1. Install the amazon.aws collection if not already done:
```
ansible-galaxy collection install amazon.aws
```
2. Configure your ansible.cfg to use the dynamic inventory plugin:
```
[defaults]
inventory = ./aws_ec2.yml
```
3. Create a aws_ec2.yml file for the dynamic inventory plugin:
yaml
```
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
  - us-west-2
filters:
  tag:Environment: Production
keyed_groups:
  - key: tags.Environment
    prefix: "env_"
  - key: tags.Role
    prefix: "role_"
```
4. Ensure your AWS credentials are set up either via environment variables, `~/.aws/credentials`, or an instance profile.

## Benefits of Dynamic Inventory:
- Automatically updates inventory based on your AWS environment.
- Organizes instances into groups using metadata such as tags or instance roles.
- Eliminates the need for manual updates to static inventory files.

Using the built-in dynamic inventory plugin is ideal for managing cloud-based environments where servers are frequently added or removed.


### Key Details:
Groups: Servers are grouped into `[STAGING_LINUX]`, `[PROD_LINUX]`, and `[PROD_UBUNTU]`.
Host Details: Each server has an ansible_host IP address and optional parameters like `ansible_user` or `ansible_ssh_private_key_file` for specific access configurations.
This structure allows you to target groups or individual hosts when running playbooks.

## Playbooks and Roles
### create_file.yml
Creates files with dynamic content:

- File contents are templated using the `{{ mytext }}` variable.
- Alternative: Use the `delegate_to` directive to create files on a different host.

### create_folder.yml
Creates directories with specific permissions:

- Example:
```
- name: Create folder1
  file:
    path: /home/secret/folder1
    state: directory
    mode: 0755
```

### playbook.yml
Main playbook to execute tasks and roles:

- Dynamic Variables: Example of encrypted variable `admin_pass` using Ansible Vault.
- Task Examples:
- - Deregister servers from a load balancer using the `shell` module.
- - Include external task files (`import_tasks` and `include_tasks`).
- - Handle errors with `ignore_errors: yes`.

Commented Sections Explained:
- failed_when: Control task failure behavior based on conditions
```
# failed_when: "'World' in results.stdout"
# failed_when: result.rc == 0
```

## Role: deploy_apache_web
This role installs and configures Apache, deploys the custom web page, and restarts the service when necessary.

### tasks/main.yml
Key Tasks:

- Ping servers to check connectivity.
- Install Apache based on the OS family.
- Deploy the index.j2 template and configure the web server.

Commented Alternatives:
- Loop Example: Copy multiple files using loop
```
template: src={{ item }} dest={{ destin_folder }} mode=0555
loop:
  - "index.html"
  - "1.jpg"
  - "2.jpg"
  - "3.jpg"
```

### templates/index.j2
HTML page template with placeholders for dynamic variables:

- `{{ owner }}`: Owner of the server.
- `{{ ansible_hostname }}`: Hostname of the server.
- `{{ ansible_os_family }}`: OS family.

### handlers/main.yml
Handlers to restart Apache:

- Conditional based on OS family (RedHat or Ubuntu).

## Usage
1. Set Up Inventory: Modify hosts.txt with your servers.
2. Run the Playbook:
```
ansible-playbook playbook.yml --ask-vault-pass
```
3. Verify: Check that Apache is installed and the web page is deployed.

## Features
- Conditional role execution based on OS family.
- Secure variable management with Ansible Vault.
- Dynamic task imports and includes.
- Configurable web server deployment using templates.

## Commented Code Explanation
The commented code snippets in the tasks illustrate alternatives to achieve similar goals:

- Conditional Failures: Customize when a task should fail based on output or return codes.
- Task Loops: Process multiple files dynamically with `loop`.
- Task Delegation: Run tasks on different hosts with `delegate_to`