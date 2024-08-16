*** Settings ***
Library    OperatingSystem
Library    Process
Library    RequestsLibrary
Library    DatabaseLibrary

*** Variables ***
${DB_HOST}         localhost
${DB_NAME}         testdb
${DB_USER}         user
${DB_PASSWORD}     password
${API_BASE_URL}    https://jsonplaceholder.typicode.com

*** Test Cases ***

# OS Operations (15 Test Cases)
Check Home Directory Exists
    Directory Should Exist    ${HOME}

Create Temporary Directory
    Create Directory    /tmp/test_directory
    Directory Should Exist    /tmp/test_directory

Remove Temporary Directory
    Remove Directory    /tmp/test_directory
    Directory Should Not Exist    /tmp/test_directory

Create Temporary File
    Create File    /tmp/test_file.txt    This is a test file.
    File Should Exist    /tmp/test_file.txt

Delete Temporary File
    Remove File    /tmp/test_file.txt
    File Should Not Exist    /tmp/test_file.txt

List Files in Directory
    ${files}=    List Files In Directory    ${HOME}
    Log    ${files}

Check Disk Space
    ${disk_space}=    Get File Size    /
    Log    Available disk space: ${disk_space} bytes

Copy File
    Create File    /tmp/test_file.txt    Test content.
    Copy File    /tmp/test_file.txt    /tmp/copied_test_file.txt
    File Should Exist    /tmp/copied_test_file.txt

Move File
    Move File    /tmp/copied_test_file.txt    /tmp/moved_test_file.txt
    File Should Exist    /tmp/moved_test_file.txt

Rename File
    Rename File    /tmp/moved_test_file.txt    /tmp/renamed_test_file.txt
    File Should Exist    /tmp/renamed_test_file.txt

Check File Permissions
    ${permissions}=    Get File Permissions    /tmp/renamed_test_file.txt
    Log    File permissions: ${permissions}

Change File Permissions
    Change File Permissions    /tmp/renamed_test_file.txt    777
    ${permissions}=    Get File Permissions    /tmp/renamed_test_file.txt
    Should Be Equal    ${permissions}    -rwxrwxrwx

Create and Delete Symbolic Link
    Create Link    /tmp/renamed_test_file.txt    /tmp/symlink_to_test_file
    File Should Exist    /tmp/symlink_to_test_file
    Remove File    /tmp/symlink_to_test_file
    File Should Not Exist    /tmp/symlink_to_test_file

Check Environment Variables
    ${path}=    Get Environment Variable    PATH
    Log    ${path}

# Process Management (10 Test Cases)
Run Echo Command
    ${result}=    Run Process    echo    Hello, World!
    Log    ${result.stdout}
    Should Be Equal    ${result.stdout.strip()}    Hello, World!

Check Process Status
    ${pid}=    Start Process    sleep    10
    ${status}=    Get Process Status    ${pid}
    Log    ${status}
    Kill Process    ${pid}

Run Background Process
    Start Process    sleep    30    shell=True    alias=sleeping
    Process Should Be Running    sleeping

Kill Background Process
    Kill Process    sleeping
    Process Should Not Be Running    sleeping

Execute Shell Script
    Create File    /tmp/test_script.sh    echo "Test script execution"
    ${result}=    Run Process    bash    /tmp/test_script.sh
    Log    ${result.stdout}
    Should Be Equal    ${result.stdout.strip()}    Test script execution

Run Python Script
    Create File    /tmp/test_script.py    print("Python script executed")
    ${result}=    Run Process    python3    /tmp/test_script.py
    Log    ${result.stdout}
    Should Be Equal    ${result.stdout.strip()}    Python script executed

Run Long-Running Process
    Start Process    sleep    60    shell=True    alias=longsleep
    Process Should Be Running    longsleep
    Kill Process    longsleep

Check Process Output
    ${result}=    Run Process    ls    /
    Log    ${result.stdout}
    Should Contain    ${result.stdout}    bin

Check Process Error Handling
    ${result}=    Run Process    ls    /nonexistent_directory
    Log    ${result.stderr}
    Should Contain    ${result.stderr}    No such file or directory

# API Testing (10 Test Cases)
Get API Response
    Create Session    jsonplaceholder    ${API_BASE_URL}
    ${response}=    Get Request    jsonplaceholder    /posts/1
    Status Should Be    200    ${response}

Check API JSON Content
    ${response}=    Get Request    jsonplaceholder    /posts/1
    ${json}=    To JSON    ${response.content}
    Should Contain    ${json['title']}    sunt aut facere repellat

Post Data to API
    ${data}=    Create Dictionary    title=Test    body=This is a test post.    userId=1
    ${response}=    Post Request    jsonplaceholder    /posts    json=${data}
    Status Should Be    201    ${response}

Put Data to API
    ${data}=    Create Dictionary    title=Updated Title
    ${response}=    Put Request    jsonplaceholder    /posts/1    json=${data}
    Status Should Be    200    ${response}
    ${json}=    To JSON    ${response.content}
    Should Be Equal As Strings    ${json['title']}    Updated Title

Delete API Data
    ${response}=    Delete Request    jsonplaceholder    /posts/1
    Status Should Be    200    ${response}

Check API Response Headers
    ${response}=    Get Request    jsonplaceholder    /posts/1
    ${headers}=    Get Response Headers    ${response}
    Log    ${headers}
    Should Contain    ${headers['Content-Type']}    application/json

Validate API Error Response
    ${response}=    Get Request    jsonplaceholder    /posts/invalid_id
    Status Should Be    404    ${response}

Check API Authentication
    ${response}=    Get Request    jsonplaceholder    /posts/1    headers=Authorization=Bearer invalid_token
    Status Should Be    401    ${response}

Check API Rate Limiting
    :FOR    ${i}    IN RANGE    1    11
    \    ${response}=    Get Request    jsonplaceholder    /posts/1
    \    Log    Attempt ${i}: ${response.status_code}
    Should Be Equal As Numbers    ${response.status_code}    429

Check API Pagination
    ${response}=    Get Request    jsonplaceholder    /posts?_page=1&_limit=10
    ${json}=    To JSON    ${response.content}
    Length Should Be    ${json}    10

# Database Testing (5 Test Cases)
Connect to Database
    Connect To Database    pymysql    ${DB_HOST}    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}

Insert Data into Database
    Execute SQL    INSERT INTO users (name, email) VALUES ('Test User', 'test@example.com')
    ${result}=    Execute SQL    SELECT COUNT(*) FROM users WHERE email='test@example.com'
    Should Be Equal As Numbers    ${result[0][0]}    1

Update Database Record
    Execute SQL    UPDATE users SET name='Updated User' WHERE email='test@example.com'
    ${result}=    Execute SQL    SELECT name FROM users WHERE email='test@example.com'
    Should Be Equal As Strings    ${result[0][0]}    Updated User

Delete Database Record
    Execute SQL    DELETE FROM users WHERE email='test@example.com'
    ${result}=    Execute SQL    SELECT COUNT(*) FROM users WHERE email='test@example.com'
    Should Be Equal As Numbers    ${result[0][0]}    0

Disconnect from Database
    Disconnect From Database
