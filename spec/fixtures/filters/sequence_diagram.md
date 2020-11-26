```sequence_diagram
Participant Browser
Participant App
Participant Vonage
Note over App,Vonage: Initialization
Browser->>App: User registers by \nsubmitting number
App->>Vonage: Number Insight request
Vonage-->>App: Number Insight response
Note over App,Vonage: If Number Insight shows that the \nuser and their phone are in different \ncountries, start the verification process
App->>Vonage: Send verification code to user's phone
Vonage-->>App: Receive acknowledgement that\nverification code was sent
App->>Browser: Request the code from the user
Browser->>App: User submits the code they received
App->>Vonage: Check verification code
Participant Vonage
Vonage-->>App: Code Verification status
Note over Browser,App: If either Number Insight response or verification step \nis satisfactory, continue registration
App->>Browser: Confirm registration
Operative-->>Application: testing a url /test/answer_outbound inside diagram
```
