==============================================================================
Api Suite                                                                     
==============================================================================
*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com
&{HEADERS}        Content-Type=application/json

*** Test Cases ***
# 1. Simple GET Request
Simple GET Request
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      GET On Session     jsonplaceholder    /posts/1    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Log To Console    ${response.json()}

# 2. GET Specific Post
GET Specific Post
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      GET On Session     jsonplaceholder    /posts/2    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Log To Console    ${response.json()}

# 3. GET All Posts
GET All Posts
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      GET On Session     jsonplaceholder    /posts    heders=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Length Should Be    ${response.json()}    100
    Log To Console    ${response.json()}

# 4. GET Posts with Query Parameters
GET Posts with Query Parameters
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${params}=        Create Dictionary   userId=1
    ${response}=      GET On Session     jsonplaceholder    /posts    params=${params}    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Length Should Be Greater Than    ${response.json()}    0
    Log To Console    ${response.json()}

# 5. POST Create New Post
POST Create New Post
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${data}=          Create Dictionary   title=foo    body=bar    userId=1
    ${response}=      POST On Session     jsonplaceholder    /posts    json=${data}    headers=${HEADERS}
    Should Be Equal As Numbers    201    ${response.status_code}
    Dictionary Should Contain Value    ${response.json()}    foo
    Log To Console    ${response.json()}

# 6. PUT Update Post
PUT Update Post
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${data}=          Create Dictionary   id=1    title=foo_updated    body=bar_updated    userId=1
    ${response}=      PUT On Session     jsonplaceholder    /posts/1    json=${data}    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Dictionary Should Contain Value    ${response.json()}    foo_updated
    Log To Console    ${response.json()}

# 7. PATCH Update Post Title
PATCH Update Post Title
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${data}=          Create Dictionary   title=patched_title
    ${response}=      PATCH On Session   jsonplaceholder    /posts/1    json=${data}    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Dictionary Should Contain Value    ${response.json()}    patched_title
    Log To Console    ${response.json()}

# 8. DELETE Post
DELETE Post
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      DELETE On Session    jsonplaceholder    /posts/1    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Log To Console    ${response.status_code}

# 9. GET Non-Existent Post
GET Non-Existent Post
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      GET On Session     jsonplaceholder    /posts/9999    headers=${HEADERS}
    Should Be Equal As Numbers    404    ${response.status_code}
    Log To Console    ${response.status_code}

# 10. GET Comments for Post
GET Comments for Post
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      GET On Session     jsonplaceholder    /posts/1/comments    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Length Should Be Greater Than    ${response.json()}    0
    Log To Console    ${response.json()}

# 11. GET All Users
GET All Users
    Create Session    jsonplaceholder    ${BASE_URL}    verify=False
    ${response}=      GET On Session     jsonplaceholder    /users    headers=${HEADERS}
    Should Be Equal As Numbers    200    ${response.status_code}
    Length Should Be    ${response.json()}    10
    Log To Console    ${response.json()}
~
~
~

