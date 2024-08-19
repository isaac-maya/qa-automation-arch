
# QA Automation Architecture

This repository showcases a robust QA Automation Architecture using Jenkins, Ansible, Ubuntu, and Robot Framework. The setup is designed to automate the execution of API, backend, and UI tests within isolated environments, leveraging LXD containers for consistency and scalability.

## Architecture

The architecture comprises the following key components:

- **Jenkins Controller**: Manages the overall automation pipeline, including scheduling, triggering, and monitoring test executions.
- **Jenkins Agents**: These are LXD containers configured to run the test cases. Two agent types are configured: one for API tests and another for UI tests.
- **Ansible**: Utilized for configuration management and automation of the Jenkins setup and LXD container provisioning.

### Workflow
1. **Jenkins Controller Setup**: Ansible playbook installs Jenkins, sets up required plugins, and configures the controller.
2. **Jenkins Agent Setup**: Agents are configured in LXD containers to execute specific test types (API/UI) based on the Jenkins pipelines.
3. **Test Execution**: Test cases are executed within the LXD containers, ensuring isolated and consistent test environments.

### How to Approach Reading the Code

If you use the `tree` command to visualize the directory structure, it becomes easy to start to grasp the role of each file:

\`\`\`
.
├── README.md
├── ansible_playbooks
│   ├── build_jenkins_api_agent.yml
│   ├── build_jenkins_controller.yml
│   └── build_jenkins_ui_agent.yml
├── hosts.ini
├── jenkins_pipelines
│   ├── api_pipeline
│   ├── backend_pipeline
│   ├── test_pipeline
│   └── ui_pipeline
├── setup_api_agent.sh
├── setup_controller.sh
├── setup_ui_agent.sh
└── tests
    ├── test_api.robot
    ├── test_backend.robot
    └── test_ui.robot

4 directories, 15 files
\`\`\`

At the top level, you'll find the `README.md`, a `hosts.ini` file, and three setup shell scripts. These shell scripts are essentially Ansible commands saved for convenience, allowing you to easily build one Jenkins controller and two Jenkins agents. Running these scripts with `bash` initiates the Ansible playbooks:

\`\`\`
ansible-playbook -vv -i hosts.ini ansible_playbooks/build_jenkins_controller.yml --ask-become-pass
\`\`\`

By examining the Ansible commands, you can infer the purpose of each directory, particularly the `ansible_playbooks` directory, which contains the detailed instructions to build the Jenkins machines. The `hosts.ini` file specifies the IP addresses of the three Jenkins machines.

### Why Use Ansible?

Ansible is a powerful tool for configuration management, allowing you to centralize and automate the setup process. Instead of manually copying scripts to each machine and executing them, Ansible enables you to manage everything from a single location (your laptop) with simple commands. This level of automation streamlines the process and reduces the chance of errors.

For example, when setting up the Jenkins controller, the Ansible playbook performs typical Linux administrative tasks such as updating repositories, installing Jenkins and its dependencies, and setting up container technology (LXD) for running tests in isolated environments. Once the setup is complete, the terminal output will provide the IP address and the initial password for the Jenkins controller, allowing you to configure it further.

Here’s an excerpt from the `build_jenkins_controller.yml` playbook:

\`\`\`yaml
- name: Install Jenkins as a controller on a remote Ubuntu machine
  hosts: jenkins_controller
  become: yes
  tasks:
    - name: Update package list
      apt:
        update_cache: yes

    - name: Install Java and dependencies
      apt:
        name:
          - openjdk-17-jre
          - fontconfig
          - gnupg
        state: present

    - name: Install LXD
      community.general.snap:
        name: lxd
        state: present

    - name: Initialize LXD
      command: lxd init --auto

    - name: Download Jenkins key
      get_url:
        url: https://pkg.jenkins.io/debian/jenkins.io-2023.key
        dest: /usr/share/keyrings/jenkins-keyring.asc

    - name: Add Jenkins repository
      apt_repository:
        repo: "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/"
        filename: "jenkins"

    - name: Install Jenkins
      apt:
        name: jenkins
        state: present

    - name: Enable Jenkins service
      systemd:
        name: jenkins
        enabled: yes
        state: started

    - name: Fetch initial Jenkins admin password
      command: cat /var/lib/jenkins/secrets/initialAdminPassword
      register: jenkins_password

    - name: Retrieve IP address of the machine
      command: hostname -I
      register: ip_address

    - name: Display Jenkins initial admin password and IP address
      debug:
        msg: "Jenkins initial admin password: {{ jenkins_password.stdout }}
Jenkins server IP address: {{ ip_address.stdout }}"
\`\`\`

### Setting Up Jenkins

Once the Jenkins controller is installed, you can configure it by installing necessary plugins, such as:

- Robot Framework
- HTML Publisher
- DataTables.net API
- SSH Agent
- SSH Pipeline Steps

This setup prepares your Jenkins controller to manage the automation pipelines effectively.

### 1. Clone the Repository
\`\`\`bash
git clone https://github.com/isaac-maya/qa-automation-arch.git
cd qa-automation-arch
\`\`\`

### 2. Setup Jenkins Controller
\`\`\`bash
ansible-playbook -i hosts.ini ansible_playbooks/build_jenkins_controller.yml --ask-become-pass
\`\`\`

### 3. Setup Jenkins Agents
\`\`\`bash
# For API Agent
ansible-playbook -i hosts.ini ansible_playbooks/build_jenkins_api_agent.yml --ask-become-pass

# For UI Agent
ansible-playbook -i hosts.ini ansible_playbooks/build_jenkins_ui_agent.yml --ask-become-pass
\`\`\`

