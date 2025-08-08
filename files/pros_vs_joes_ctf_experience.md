# Pros vs Joes CTF 2025 - Team B4FFL3G4P Experience

So... we just wrapped up Pros vs Joes CTF 2025, and holy shit, what a ride. Team B4FFL3G4P came together and made some magic happen. I tried for a few weeks prior to set up a few tools and workflows to use during the PVJ CTF. I'm happy with the progress on most of them, just sad I didn't get to use them during the game. Honestly, I feel like I kinda get overwhelmed from all the in-person interaction. Also from while leading and playing the CTF I guess I'm popular because I had 6-7 friends come and say hi while trying to focus up. CHAOS... I mean the red team is literally fucking us the entire game - this is the "spirit" of the game. In the real world, we cut the internet, not allowing the communications, and making remediations. In this game our priority is accessibility to the Bad Actors (Red team).

**The TL;DR:** We had an incredible team with Coldren (UK incident response god), outofmemory (DNS champion), Bri_tney (Windows security wizard), Shawn (recovery specialist), Oscar & B4k3ry (red team allies), and Punch Stain (pfSense ThunderCock). I spent weeks building tools (Enhanced Desktop Goose, DPR C2, Wazuh EDR policies, attack automation) but barely used them because CTF chaos is real. Being staff + team captain pulled me in too many directions, but our team chemistry was perfect. Coldren handled incident response like a boss, outofmemory kept DNS alive, Bri_tney hardened Windows systems, Shawn used PetitPotam/Juicy Potato to recover access when our controls backfired, and Punch was everywhere configuring firewalls. The red team constantly attacked us (as they should), but we adapted and kept services running. I learned that preparation is everything, team chemistry matters more than tools, and sometimes the best leadership is getting out of the way. Next year I want to actually use the tools I built and find better balance between staff and captain roles. CTF Factory, Dichotomy, and Gold team ran an amazing event. Team B4FFL3G4P was legendary - every person brought unique skills and we worked like a well-oiled machine even when shit went sideways.

**During the game, I worked on:** Mail server recovery (fixing Postfix on mail0, port 25 issues, SASL authentication), DNS infrastructure (BIND9 setup on ns0, zone management, anomaly detection), user account management (cleaning up red team accounts, creating admin_clean/backup_admin, deploying universal SSH keys), threat hunting (process analysis, network monitoring, IOC collection), forensics analysis (UAC tool collection, analyzing icanhasaccess activity, reviewing auth logs), attack automation (Day 2 scripts, network scanning, credential testing), pfSense firewall management (password resets, configuration), offensive operations (deploying persistence.sh and troll.sh scripts, custom malware deployment, running annoying website with troll/bad Java content, leaving "I'll be back" messages on blue team screens, psychological warfare campaigns), web server setup (file sharing, documentation, offensive platform), and comprehensive Wazuh EDR policies for Windows/Linux. Also maintained communication via slack and discord throughout the event and captured extensive screenshots of offensive operations.

Let me break down what I remember that happened, who I think did what, and why this CTF was both amazing and exhausting.

---

## Team B4FFL3G4P - The Good, The Bad, The ThunderCock

### **Leadership (AKA The Chaos Coordinators)**
- **Punch Stain:** Co-captain, pfSense wizard, and the human equivalent of a Swiss Army knife - smart, strong, and somehow both good and evil at the same time
- **Me (Forgetfulelephant):** Co-captain, strategic mess-maker, and the guy who spent way too much time building tools that we barely used (more on that later). I have tons of feelings about this game and they all stem from the chaos and love you experience during.

### **The Heavy Hitters**

**Coldren** - This dude is from the UK and he's basically a cybersecurity god. Incident response? Check. Network analysis? Check. Setting up RunZero and Wazuh agents? Check. The man was handling task after task like it was nothing. PCAP analysis, Linux machine management, kicking out bad guys - you name it, he did it. The whole game he was just... working. Non-stop. It was beautiful to watch. I wish more work with this guy happens in the future.

**outofmemory** - Our DNS champion. This guy got us TONS of points and learned a shitload in the process. He was constantly working on Linux machines and specifically keeping our BIND9 DNS running. When DNS goes down, everything goes to hell, and this guy kept it alive. Absolute legend.

**Bri_tney** - Our Windows champion. Setting up STIGs, GPOs, and other Windows security stuff to try and kick the bad guys out. Windows security is its own special kind of hell, and this person handled it like a pro.

**Shawn** - The recovery specialist. This guy helped with both Windows and Linux, and specifically got us back into our Windows machines when some of our controls backfired and locked even US out. He used PetitPotam/Juicy Potato to escalate a user account to NT AUTHORITY/SYSTEM when we got locked out from our own controls. When shit hits the fan, you want this guy on your team.

### **The Red Team Allies (AKA The Chaos Makers)**

**Oscar** - My red team ally. He assisted in getting us on Linux machines and dropping our beacons. He also set up a way to install Wazuh to more machines. When you need someone to get into enemy systems and stay there, Oscar's your guy.

**B4k3ry** - Another red team ally. This person was grabbing shells on enemy boxes through different services and automating our beacons. The automation part was key - when you're in a CTF, you don't have time to manually hack every box.

### **Punch Stain - The ThunderCock Himself**

Oh my god, Punch... THUNDERCOCK HO!!!!! This man is like Superman and Lex Luthor in one. Smart, strong, charismatic, good, and omg evil. He was the champion of the pfSense firewall. Day 1 he was jumping all over the place. I think it being his first time captaining and also running so hard at things needed to be done like on the firewall, he might have gotten a bit tired out by the end. But dude.... this guy has so much talent, smarts, and experience. If you ever get a chance to work with Punch, do it. Just... do it.

---

## What Actually Happened (The Real Story)

### **Day 1 - The Chaos Begins**

So we started with this grand plan. I had spent weeks building this workspace with all these tools - enhanced Desktop Goose, DPR C2 framework, Wazuh EDR policies, attack automation scripts, DNS management tools, threat hunting capabilities. I was ready to unleash hell.

And then reality hit.

Being added on as staff last minute and co-leading Team B4FFL3G4P, I felt like not only did I get distracted from the plan but pulled away from it. Instead of using all the cool shit I built, I was mostly helping every individual keep to what they were doing the majority of the game.

### **The Grey Team Support**

I mostly helped facilitate points grabs from the grey team who asked for specific things like IT stuff. "Can you set up these users for access?" "Can you install an EDR and give us some detection policies?" That kind of thing. I worked on trying to grab some artifacts for analysis, unpacked some information on the network traffic captures, and dropped a few beacons.

---

## What You and I Actually Worked On (The Real Grind)

### **Mail Server Hell - The Postfix Saga**

So there was this mail server, mail0, that was completely fucked. Postfix was masked, inactive, had SASL authentication issues, and wasn't listening on port 25. The `mail` command was missing entirely. I spent way too much time trying to fix this thing.

I remember creating script after script trying to get this damn mail server working - `fix_mail0_final.sh`, `fix_port25.sh`, `fix_postfix.sh`, `setup_mail0_services.sh`. Every time I thought I had it fixed, something else would break. It was like playing whack-a-mole with a mail server.

The SASL authentication was particularly annoying. I kept getting these errors about authentication failures, and the port 25 just wouldn't open. I think I spent like 3 hours just trying to get this one service running. In hindsight, maybe I should have just given up and focused on something else, but I'm stubborn like that.

### **DNS Infrastructure - The BIND9 Chronicles**

outofmemory was the main DNS person, but I helped create a bunch of automation tools for him. I built `setup_dns_ns0.sh`, `dns_zone_manager.sh`, `dns_monitor.sh`, and `dns_anomaly_detector.sh`. 

The idea was to make DNS management easier and catch any weird activity. The anomaly detector was supposed to flag unusual DNS queries, and the zone manager was going to help with zone file updates. outofmemory was already handling the main DNS stuff like a boss, so these were just support tools to make his life easier.

I remember thinking "man, DNS is so much more complex than I realized" while working on these scripts. There's so much that can go wrong with DNS - zone transfers, recursive queries, cache poisoning, you name it. outofmemory made it look easy though.

### **User Account Cleanup - The Red Team Hunt**

This was actually kind of fun. I created `clean_and_create_accounts.sh` and `cleanup_ns0_users.sh` to get rid of the red team accounts (icanhasaccess, goldteamscoring) and set up our own clean accounts.

The tricky part was doing this without breaking anything that was already working. I had to be careful not to delete accounts that were actually being used by legitimate services. I remember spending time checking which accounts were active and which were just leftover from red team activity.

I also set up universal SSH keys using `deploy_universal_key.sh` and `deploy_key.sh`. The idea was to have one key that could access all our Linux machines. This actually worked pretty well - I could SSH into any of our boxes without having to remember different passwords.

### **Threat Hunting - The UAC Forensics Adventure**

This was probably the most interesting part for me. I got to analyze the Unix Artifact Collector (UAC) data from podctl0. It was like being a digital detective.

I found all this activity from the red team - legitimate stuff from July 27 (Ansible automation deployment) and August 4 (active session with UAC tool running). It was fascinating to see how they operated. They were using Ansible for automation, which makes sense for a red team trying to scale their operations.

I spent time going through auth logs, process information, and user activity. It was like piecing together a puzzle - trying to understand what the red team was doing, when they were doing it, and how they were maintaining access.

The cool thing was seeing how professional they were about it. They weren't just randomly hacking around - they had a systematic approach with proper tools and automation.

### **Attack Automation - The Day 2 Planning**

I spent a lot of time on this one. I created `day2_attack_scripts.sh`, `day2_attack_improved.sh`, and `day2_attack_plan.md`. The idea was to have a comprehensive attack plan ready for Day 2.

These scripts included network scanning, credential testing, SSH/RDP attacks, and persistence deployment. I was trying to automate as much as possible so we could focus on the strategic stuff rather than manual recon.

The network scanning was targeting the enemy networks (100.80.4.x, 100.80.6.x, 100.80.8.x) with nmap, testing default credentials, and identifying vulnerable services. I remember thinking "man, this is going to be awesome when we actually use it."

Spoiler alert: we barely used any of it. CTF chaos is real.

### **pfSense Firewall Drama**

I helped with some pfSense firewall management, including password resets and configuration recovery. I remember there was this one time where the admin account got locked out and we had to reset it through the console.

Punch was the main pfSense person, but I helped with some of the basic stuff. He was using the static package manager config because the red team was trying to use pfSense for bad with the other package managers. Firewalls are always tricky - you want to be secure, but you also need to make sure legitimate traffic can get through. It's a constant balancing act.

### **Wazuh EDR Policies - The Documentation Grind**

I created this massive `wazuh_edr_policies.md` document with custom rules for Windows and Linux systems. It included detection rules, active response scripts, and SCA policies.

This was actually pretty comprehensive - I covered everything from process injection detection to privilege escalation monitoring. The idea was to have a complete EDR policy that could catch the kind of attacks we were seeing in the CTF.

I remember thinking "this is going to be so useful" while I was writing it. And then during the actual CTF, we barely referenced it. Such is life.

### **Web Server and Documentation**

I maintained our project workspace and web server throughout the event. This included file sharing, documentation updates, and keeping the blog current.

The web server was actually pretty useful - it let us share files and documentation easily. I updated the main blog with our CTF experience and kept all the project documentation organized.

It's funny how the simple stuff like file sharing and documentation becomes so important during an event like this. When you're in the middle of chaos, having organized information is gold.

---

## The Offensive Operations (The Fun Stuff)

### **Persistence and Troll Scripts - The Chaos Deployment**

So here's where it gets interesting. I actually got to use some of the offensive tools I built, and it was glorious. I deployed `persistence.sh` and `troll.sh` scripts across enemy systems. These weren't just basic persistence - they were designed to be annoying as hell while maintaining access.

The `troll.sh` script was particularly fun. It would create random pop-ups, change desktop backgrounds, and generally make life miserable for the blue team. I remember thinking "if they're going to attack us, we might as well make it memorable."

I also tried deploying some custom malware - nothing destructive, just proof-of-concept stuff to see what we could get away with. The goal was to test their detection capabilities and see how they'd respond.

### **The Annoying Website - Psychological Operations**

I had my webpage running with all the troll/annoying site/bad Java stuff. This wasn't just about technical attacks - it was psychological warfare. The idea was to get into their heads, make them question what was real and what wasn't.

The website had all kinds of annoying features - pop-ups that couldn't be closed, fake error messages, redirects to nowhere. It was like digital gaslighting. I remember thinking "if they're going to spend time dealing with this crap, they're not spending time attacking us."

### **Blue Team Messaging - The "I'll Be Back" Campaign**

This was probably my favorite part. I started leaving notes on blue team screens saying "I'll be back" and other ominous messages. It was like being a digital boogeyman - they'd log into their machines and find these messages waiting for them.

I remember thinking "this is going to freak them out" and it totally did. They started reporting these messages in their incident reports, and it was hilarious to watch them try to figure out how we were getting access to their systems.

The psychological impact was real - they were spending time investigating these instead of focusing on their own attacks. It was like digital misdirection.

### **Screenshot Evidence - The Digital Trail**

I captured a bunch of screenshots throughout the offensive operations (check out the docs/screencaps folder). These show everything from successful access to error messages to the results of our troll campaigns.

The screenshots tell a story - you can see the progression from initial access to full system compromise to the aftermath of our attacks. It's like a digital crime scene, except we were the ones committing the crimes.

Some of the screenshots show the blue team's response to our attacks - their incident reports, their attempts to clean up our messes, their confusion about what was happening. It's fascinating to see the other side of the attack.

### **The Web Server Offensive Platform**

My web server wasn't just for documentation - it became an offensive platform. I was serving files, hosting tools, and providing access to all the offensive capabilities we'd built. It was like having a digital arsenal that we could deploy at will.

The cool thing was that it looked like a legitimate web server from the outside, but it was actually serving up all kinds of offensive tools and payloads. It was like hiding weapons in plain sight.

### **The Results - What Actually Worked**

The offensive operations were surprisingly effective. We got access to multiple enemy systems, deployed persistence mechanisms, and created enough chaos that the blue team had to spend significant time dealing with our attacks.

The psychological operations were particularly successful - the "I'll be back" messages and annoying website features created real confusion and concern among the blue team. They were spending time investigating these instead of focusing on their own objectives.

The screenshots show the progression of our attacks and the blue team's responses. You can see them trying to clean up our messes, investigating our persistence mechanisms, and generally being confused about what was happening.

### **Lessons Learned from Offensive Operations**

1. **Psychological warfare works.** Sometimes the most effective attack is the one that gets into their heads.

2. **Persistence is key.** Having multiple ways to maintain access is crucial when the blue team is actively trying to kick you out.

3. **Documentation matters.** The screenshots and logs from our offensive operations provide valuable lessons for future engagements.

4. **Adaptation is everything.** When one attack vector gets blocked, you need to have alternatives ready.

---

## The Tools I Built (And Barely Used)

So here's the thing - I spent weeks building this workspace with all these cool tools:

- **Enhanced Desktop Goose:** Modified C# application with network communication, process monitoring, and data collection
- **DPR C2 Framework:** Custom command and control with WebSocket communication, DNS tunneling, and steganography  
- **Wazuh EDR Policies:** Custom detection rules for Windows and Linux
- **Attack Automation:** Day 2 offensive scripts and tools
- **DNS Management:** Automated zone management and monitoring
- **Threat Hunting:** Process and network analysis tools

And we barely used any of it.

Why? Because when you're in the middle of a CTF, you're dealing with immediate fires. You don't have time to deploy new tools or test new capabilities. You're putting out fires, keeping services running, and trying to score points.

But here's the thing - having that workspace ready meant I could quickly adapt when needed. When we needed to deploy SSH keys across multiple machines, I had scripts ready. When we needed to set up DNS monitoring, I had tools ready. When we needed to clean up user accounts, I had automation ready.

So maybe we didn't use everything I built, but having it there was like having a Swiss Army knife in your pocket - you might not use every tool, but when you need one, it's there.

---

## The Reality Check

CTF Factory, Dichotomy, and the Gold team did fantastic jobs with this event. I feel that they are running a great show and providing people wonderful opportunities.

But here's what I learned about myself and leadership:

1. **Being staff and team captain is hard.** You get pulled in multiple directions and it's hard to focus on your own team's objectives.

2. **Preparation is everything.** Having tools ready, even if you don't use them all, gives you options when shit hits the fan.

3. **Team chemistry matters.** When you have people like Coldren, outofmemory, Bri_tney, Shawn, Oscar, B4k3ry, and Punch on your team, you can handle almost anything.

4. **Sometimes the best leadership is getting out of the way.** Let people do what they're good at, and just help coordinate.

---

## What's Next

So for next year, I have a few goals:

1. **Use more of the tools I build.** I want to actually deploy some of this stuff and see it in action.

2. **Better balance between staff and team captain roles.** Figure out how to do both without getting pulled away from the team.

3. **More offensive operations.** I want to actually use some of the offensive tools I built.

4. **Better documentation.** Having tools ready is great, but having them documented and easy to deploy is even better.

---

## Final Thoughts

Team B4FFL3G4P was amazing. Every single person brought something unique to the table, and we worked together like a well-oiled machine. Even when things went sideways (and they did), we adapted and kept moving forward.

The CTF was challenging, exhausting, and absolutely worth it. I learned a ton about leadership, team dynamics, and the reality of cybersecurity operations.

And Punch? Dude, you're a legend. ThunderCock for life.

---

*This is the real story of Team B4FFL3G4P at Pros vs Joes CTF 2025. No corporate speak, no bullshit, just what actually happened and what we learned from it.*