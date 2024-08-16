==============================================================================
Wikipedia Web UI Suite
==============================================================================
*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                 https://www.wikipedia.org
${CHROME DRIVER PATH}  /usr/bin/chromedriver
${BROWSER PATH}        /usr/bin/chromium-browser
${BROWSER OPTIONS}     --no-sandbox --disable-dev-shm-usage --headless --disable-gpu --remote-debugging-port=9222

*** Keywords ***
Open Browser With Custom Options
    [Arguments]    ${url}    ${browser}=chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    ${BROWSER OPTIONS}
    Set Variable    ${options.binary_location}    ${BROWSER PATH}
    Open Browser    ${url}    ${browser}    options=${options}    executable_path=${CHROME DRIVER PATH}

*** Test Cases ***
# 1. Verify Wikipedia Homepage Title
Verify Homepage Title
    Open Browser With Custom Options    ${URL}
    Title Should Be    Wikipedia
    Close Browser

# 2. Search for a Term and Verify Search Results
Search For A Term
    Open Browser With Custom Options    ${URL}
    Input Text    name=search    Robot Framework
    Click Button    xpath=//button[@type='submit']
    Wait Until Page Contains Element    xpath=//h1[text()='Search results']
    Page Should Contain    Robot Framework
    Close Browser

# 3. Verify Language Selection Functionality
Verify Language Selection
    Open Browser With Custom Options    ${URL}
    Click Element    css=.langlist a[lang='es']
    Wait Until Page Contains    Wikipedia, la enciclopedia libre
    Title Should Be    Wikipedia, la enciclopedia libre
    Close Browser

# 4. Verify Presence of Main Content on Homepage
Verify Main Content Presence
    Open Browser With Custom Options    ${URL}
    Wait Until Page Contains Element    id=www-wikipedia-org
    Page Should Contain Element    id=www-wikipedia-org
    Close Browser

# 5. Validate Navigation to a Random Article
Validate Random Article Navigation
    Open Browser With Custom Options    ${URL}
    Click Link    link=Random article
    Wait Until Page Contains Element    id=content
    Title Should Not Be    Wikipedia
    Close Browser

# 6. Validate Today's Featured Article Link
Validate Featured Article Link
    Open Browser With Custom Options    ${URL}
    Click Link    link=Today's featured article
    Wait Until Page Contains Element    id=mp-tfa
    Page Should Contain Element    id=mp-tfa
    Close Browser

# 7. Validate Search Suggestions Functionality
Validate Search Suggestions
    Open Browser With Custom Options    ${URL}
    Input Text    name=search    Robot
    Wait Until Page Contains Element    class=autocomplete-suggestions
    Page Should Contain Element    class=autocomplete-suggestions
    Close Browser

# 8. Verify Login Page Navigation
Verify Login Page Navigation
    Open Browser With Custom Options    ${URL}
    Click Link    link=Log in
    Wait Until Page Contains Element    id=userloginForm
    Title Should Contain    Log in - Wikipedia
    Close Browser

# 9. Validate Contents Link Navigation
Validate Contents Link
    Open Browser With Custom Options    ${URL}
    Click Link    link=Contents
    Wait Until Page Contains Element    id=mw-content-text
    Title Should Contain    Contents - Wikipedia
    Close Browser

# 10. Verify Main Page Link in Different Language
Verify Main Page Link In Different Language
    Open Browser With Custom Options    ${URL}
    Click Element    css=.langlist a[lang='fr']
    Wait Until Page Contains    Accueil
    Click Link    link=Page principale
    Wait Until Page Contains    Wikipedia, l'encyclopédie libre
    Close Browser

# 11. Validate Donate Button Navigation
Validate Donate Button Navigation
    Open Browser With Custom Options    ${URL}
    Click Link    link=Donate
    Wait Until Page Contains Element    id=donate-form
    Title Should Contain    Donate - Wikipedia
    Close Browser
