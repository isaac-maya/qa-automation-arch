README README README
# Setup Instructions

## Prerequisites
* Ubuntu 20.04 or later
* Ansible installed on the host machine
* SSH access to Jenkins controller and agent machines
* LXD installed and initialized on Jenkins agent machines

## Steps to Set Up
Configure Jenkins Controller: Run the setup_jenkins_controller.sh script to install Jenkins and configure it as a service.

```text
ansible-playbook -vv -i hosts.ini ansible_playbooks/build_jenkins_controller.yml --ask-become-pass
```

Configure Jenkins Agent: Run the setup_jenkins_agent.sh script to install Jenkins agent, set up LXD, and prepare the environment for test execution.
 ```bash
ansible-playbook -vv -i hosts.ini ansible_playbooks/build_jenkins_agent.yml --ask-become-pass
 ```
Run Pipelines:
API Pipeline: Executes API tests using Robot Framework inside an LXD container.
Test Pipeline: Demonstrates the creation, use, and deletion of LXD containers within Jenkins.


These pipelines are configured in jenkins_pipelines/ and can be triggered from the Jenkins dashboard.












How to approach reading the code?

if you ´tree´ the directory, it is easy to note the main structure of what each file does.

´´´
.
├── README.md
├── ansible_playbooks
│   ├── build_jenkins_api_agent.yml
│   ├── build_jenkins_controller.yml
│   └── build_jenkins_ui_agent.yml
├── hosts.ini
├── jenkins_pipelines
│   ├── api_pipeline
│   ├── test_pipeline
│   └── ui_pipeline
├── setup_api_agent.sh
├── setup_controller.sh
├── setup_ui_agent.sh
└── tests
    ├── test_api.robot
    ├── test_backend.robot
    └── test_ui.robot

4 directories, 14 files

´´´

On the very top level we can locate this README file. There are also a ´hosts.ini´ , and 3 setup shell scripts.
These shell scripts are really the Ansible command to build 1 Jenkins controller and 2 Jenkins agents. I just find it easier to save the command in a shell script and the run it with bash. 

´´´
ansible-playbook -vv -i hosts.ini ansible_playbooks/build_jenkins_controller.yml --ask-become-pass
isaacmaya@MacBook-Air-de-Isaac automation % cat setup_ui_agent.sh  

ansible-playbook -vvv -i hosts.ini ansible_playbooks/build_jenkins_ui_agent.yml --ask-become-pass

isaacmaya@MacBook-Air-de-Isaac automation % cat setup_api_agent.sh
ansible-playbook -vvvv -i hosts.ini ansible_playbooks/build_jenkins_api_agent.yml --ask-become-pass
´´´

By carefully reading the Ansible commands, we can infere what one of the directories at the top level contains. (ansible_playbooks)
. 

let's recap:
acording to the tree command we have 4 dirs and 14 files. We know at the top level 3 files are shell scripts that simply invoke an ansible command to build 3 jenkins machines.
The actual instructions to build the machines are the files located inside the ansible_playbooks directory. And the hosts file is where we specify which IP addresses belong to the 3 jenkins machines.

How ansible works is that it sends over ssh the instructions or commands you need to do something. In this case install stuff in 3 machines to build a Jenkins cluster.


Now ...
Let's take a look at the ansible playbooks.


So, what is the cool thing about using Ansible, or why even bother with it?
Ansible let's us merely walk the shores of a religion called configuration management.

In argot popular.

Instead of having to scp the script to each of the machines and then running it.

Now I can just have the scripts to install in one central location, in this case my laptop. And from there with just running a command get the work done.
This is automation. :)

Let do it!

These are my machines. The are vms running ubuntu.
First we will do the jenkins controller installation.

I first gather the ip addr


What happened???

so... I tried to connect to this new vm that had the same IP of an old machine I've already connected to. So The keys didn't matched.
I went and deleted the old key for the old vm, so when I retry sshing, I'll recreate a new one for the new vm!

We run the script and we can see from the playbook, tha it does regular Linux Admin stuff.
Update repos, add Jenkins repo, Install jenkins and deps adn we also install container technology.

We'll be using container to run each test in an isolated environment that can be deployed and destroyed when done.

In this case I decided to use LXD, at the end of the day I like to see this tools as tools.
So you can learn how to mill or you can learn how to use just one type of bridgeport milling machines.

Simple words maybe, you can learn how hammers work, and then you can just use any brand of hammer you like.

Well I like LXD.

When finished, we'll see that the terminal output indicates the ip and the initial password for the Jenkins controller.

Let's configure it. Which is a metter of installing the plugins to ssh to the agents and to run the Robot Framework pipelines. We will also create a user with a different password to the initial one.



isaacmaya@MacBook-Air-de-Isaac automation % cat ansible_playbooks/build_jenkins_controller.yml 
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

    - name: Update package list after adding Jenkins repository
      apt:
        update_cache: yes

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
        msg: "Jenkins initial admin password: {{ jenkins_password.stdout }}\nJenkins server IP address: {{ ip_address.stdout }}"



ADDING SSH KEY
isaacmaya@MacBook-Air-de-Isaac automation % ssh-copy-id jenkins@192.168.100.182 
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/isaacmaya/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
jenkins@192.168.100.182's password: 

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'jenkins@192.168.100.182'"
and check to make sure that only the key(s) you wanted were added.


INSTALLATION DONE

TASK [Fetch initial Jenkins admin password] *****************************************************************************
task path: /Users/isaacmaya/jobhunt_aug24/automation/ansible_playbooks/build_jenkins_controller.yml:50
changed: [192.168.100.182] => {"changed": true, "cmd": ["cat", "/var/lib/jenkins/secrets/initialAdminPassword"], "delta": "0:00:00.001506", "end": "2024-08-15 04:49:48.967305", "msg": "", "rc": 0, "start": "2024-08-15 04:49:48.965799", "stderr": "", "stderr_lines": [], "stdout": "eb9ee60ee7924bfcbbbc933ebdfabbe6", "stdout_lines": ["eb9ee60ee7924bfcbbbc933ebdfabbe6"]}

TASK [Retrieve IP address of the machine] *******************************************************************************
task path: /Users/isaacmaya/jobhunt_aug24/automation/ansible_playbooks/build_jenkins_controller.yml:54
changed: [192.168.100.182] => {"changed": true, "cmd": ["hostname", "-I"], "delta": "0:00:00.001352", "end": "2024-08-15 04:49:49.459821", "msg": "", "rc": 0, "start": "2024-08-15 04:49:49.458469", "stderr": "", "stderr_lines": [], "stdout": "192.168.100.182 10.209.12.1 fd42:db02:a9f1:f88::1 ", "stdout_lines": ["192.168.100.182 10.209.12.1 fd42:db02:a9f1:f88::1 "]}

TASK [Display Jenkins initial admin password and IP address] ************************************************************
task path: /Users/isaacmaya/jobhunt_aug24/automation/ansible_playbooks/build_jenkins_controller.yml:58
ok: [192.168.100.182] => {
    "msg": "Jenkins initial admin password: eb9ee60ee7924bfcbbbc933ebdfabbe6\nJenkins server IP address: 192.168.100.182 10.209.12.1 fd42:db02:a9f1:f88::1 "
}

PLAY RECAP **************************************************************************************************************
192.168.100.182            : ok=13   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

The plugins to install are:

Robot Framework	
HTML Publisher	
DataTables.net API	
SSH Agent	 
SSH Pipeline Steps


This is how to setup the jenkins-controller
:)
g night
