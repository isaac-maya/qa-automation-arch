# QA Automation Architecture

This repository showcases a robust QA Automation Architecture using Jenkins, Ansible, Ubuntu, and Robot Framework. The setup is designed to automate the execution of API, backend, and UI tests within isolated environments, leveraging LXD containers for consistency and scalability.

## Architecture

The architecture comprises the following key components:

- **Jenkins Controller**: Manages the overall automation pipeline, including scheduling, triggering, and monitoring test executions.
- **Jenkins Agents**: These are LXD containers configured to run the test cases. Two agent types are configured: one for API tests and another for UI tests.
- **Ansible**: Utilized for configuration management and automation of the Jenkins setup and LXD container provisioning.
- **Robot Framework**: The primary tool for writing and executing test cases across API, backend, and UI layers.

### Workflow


# QA Automation Architecture

This repository showcases a robust QA Automation Architecture using Jenkins, Ansible, Ubuntu, and Robot Framework. The setup is designed to automate the execution of API, backend, and UI tests within isolated environments, leveraging LXD containers for consistency and scalability.

## Architecture

The architecture comprises the following key components:

- **Jenkins Controller**: Manages the overall automation pipeline, including scheduling, triggering, and monitoring test executions.
- **Jenkins Agents**: These are LXD containers configured to run the test cases. Two agent types are configured: one for API tests and another for UI tests.
- **Ansible**: Utilized for configuration management and automation of the Jenkins setup and LXD container provisioning.
- **Robot Framework**: The primary tool for writing and executing test cases across API, backend, and UI layers.

### Workflow
1. **Jenkins Controller Setup**: Ansible playbook installs Jenkins, sets up required plugins, and configures the controller.
2. **Jenkins Agent Setup**: Agents are configured in LXD containers to execute specific test types (API/UI) based on the Jenkins pipelines.
3. **Test Execution**: Test cases are executed within the LXD containers, ensuring isolated and consistent test environments.

## Requirements

- **Operating System**: Ubuntu 20.04 or later
- **Ansible**: Installed on the host machine for managing the Jenkins setup.
- **SSH Access**: SSH must be configured between the host machine and the Jenkins controller/agent machines.
- **LXD**: Installed and initialized on the machines intended to run as Jenkins agents.

## Installation

### 1. Clone the Repository
\`\`\`bash
git clone https://github.com/isaac-maya/qa-automation-arch.git
cd qa-automation-arch
\`\`\`

### 2. Setup Jenkins Controller
...skipping...


# QA Automation Architecture

This repository showcases a robust QA Automation Architecture using Jenkins, Ansible, Ubuntu, and Robot Framework. The setup is designed to automate the execution of API, backend, and UI tests within isolated environments, leveraging LXD containers for consistency and scalability.

## Architecture

The architecture comprises the following key components:

- **Jenkins Controller**: Manages the overall automation pipeline, including scheduling, triggering, and monitoring test executions.
- **Jenkins Agents**: These are LXD containers configured to run the test cases. Two agent types are configured: one for API tests and another for UI tests.
- **Ansible**: Utilized for configuration management and automation of the Jenkins setup and LXD container provisioning.
- **Robot Framework**: The primary tool for writing and executing test cases across API, backend, and UI layers.

### Workflow
1. **Jenkins Controller Setup**: Ansible playbook installs Jenkins, sets up required plugins, and configures the controller.
2. **Jenkins Agent Setup**: Agents are configured in LXD containers to execute specific test types (API/UI) based on the Jenkins pipelines.
3. **Test Execution**: Test cases are executed within the LXD containers, ensuring isolated and consistent test environments.

## Requirements

- **Operating System**: Ubuntu 20.04 or later
- **Ansible**: Installed on the host machine for managing the Jenkins setup.
- **SSH Access**: SSH must be configured between the host machine and the Jenkins controller/agent machines.
- **LXD**: Installed and initialized on the machines intended to run as Jenkins agents.

## Installation

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

### 4. Configure Pipelines
- Access the Jenkins dashboard and configure the provided pipelines (`api_pipeline`, `ui_pipeline`, `test_pipeline`) as needed.

### 5. Running the Tests
Trigger the pipelines from the Jenkins dashboard to execute the test cases within the LXD containers.
