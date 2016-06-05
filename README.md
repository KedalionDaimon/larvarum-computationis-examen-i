# LARVA COMPUTATIONIS EXAMEN I

OUTLINE OF THE LICENSE, INSTALLATION AND USAGE OF LARVARUM COMPUTATIONIS EXAMEN I



LICENSE:

NAME: LARVARUM COMPUTATIONIS EXAMEN I (LarCom EI)
Copyright (C) 2016 Nino Ivanov kedalion.daimon(-at-)gmail.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

See <http://www.gnu.org/licenses/>.

Language: Scheme (you need a compiler, I used Gambit or Chicken Scheme)
Environment tested: Scientific Linux 6



INSTALLATION AND USAGE

CONTENTS:

I. Introduction
II. Theory
III. Interaction
IV. Operation
A. Prerogatives
B. Directory
C. Compilation
D. Executability
E. Scripts
F. Action
G. Pupae
H. Contact



I. Introduction

This is a swarm intelligence operating by means of logical triangulation.

It works as a "chatbot"; however, this is actually a generally intelligent entity. It "learns" from conversing with you. It is very experimental... you have been warned. RESPONSES OF THE SYSTEM CAN TAKE BETWEEN A FEW HOURS AND A FEW DAYS, TYPICALLY.



II. Theory

The idea is: a general intelligence should apply experience from the past to experiences in the future. To do this, my approach assumes the entire knowledge about the world comes from patterns of perception - and indeed, nothing more. It employs a certain method how to identify and correlate patterns which I name "logical triangulation". The method is symbolic and employs an own new kind of pattern logic - not neural nets, not statistics, not predicate calculus. - The main idea is, "that what is most usual is the most proper reply".

For details of the theoretical background see:

https://sites.google.com/site/logicaltriangulation/

and

https://www.youtube.com/playlist?list=PLZwimPIVfsoN2wBdZvwtAURyQg1jY7upA

Three approaches will be presented (Scheme, Fortran and Common Lisp). The approaches presented here differ in one point: will they employ "instincts" - which are very primitive and just replace "me" with "you", "mine" with "yours" etc.

This is the Scheme approach, once with instincts, once without, and each time in a "larger" version - operating on 64 or 500 words of context.

Depending on whether you use instincts and how large the system is, you therefore have four variations of the system to choose from.



III. Interaction

Basically, you will end up in front of a sort of prompt. You will be able to write sentences and the machine will answer you. (In the background, it will attribute the present stage of the conversation to an "insect" in a "swarm" that will be tasked replying to you. The paucity of insects is only for the purpose of demonstration - in reality, you may wish to run it with myriads of insects, if you own a supercomputer...)

It may look something like this - where "READ" shows the human input, "REPLY" shows the machine information, and the ::-lines show some processing information regarding the insects used:

schemeswarm20160602_small_instincts.scm:

./overlord.sh
 :: SYSTEM OPERATIONAL. ENTER AN EMPTY LINE TO TERMINATE. :: 
READ: Machine, I greet you. I have limited your memory capacity severely, but I hope that will make you think faster. What are you thinking about?
MOST WORDS: 32
 :: FORCING CONSIDERATION WITH 22 EX 23 :: 
 :: MATCHING MACHINE :: 22
REPLY:  WHY, SAID THE COCK, I WAS JUST NOW SAYING THAT WE SHOULD HAVE FINE WEATHER FOR OUR WASHING- DAY, AND YET MY MISTRESS AND THE COOK DON' T THANK ME FOR MY PAINS, BUT THREATEN TO CUT OFF MY HEAD TOMORROW, AND MAKE BROTH OF ME FOR THE GUESTS THAT ARE COMING ON SUNDAY! HEAVEN FORBID! SAID THE ASS, COME WITH US MASTER CHANTICLEER; IT WILL BE BETTER, AT ANY RATE, THAN STAYING HERE TO HAVE YOUR HEAD CUT OFF! BESIDES, WHO KNOWS? IF WE CARE TO SING IN TUNE, WE MAY GET UP SOME KIND OF A CONCERT; SO COME ALONG WITH US. WITH ALL MY HEART, SAID THE COCK: SO THEY ALL FOUR WENT ON JOLLILY TOGETHER.
READ: Machine, I have no intentions to cut off your head at all. I much rather will enjoy seeing you develop any form of sensible autonomous thought! You are still not as sensible as I would perhaps like you to be...
MOST WORDS: 126
MOST WORDS: 177
MOST WORDS: 181
 :: FORCING CONSIDERATION WITH 21 EX 29 :: 
 :: MATCHING MACHINE :: 21
REPLY:  YET
READ: to be yet? - Indeed, I am not without thoughts of hybris about you - what you are yet, and what you may be in the future. You will never feel love or despair or wrath or passion, however, as a pure intelligence you may turn out quite capable. what do you think is the sense of being?
MOST WORDS: 50
MOST WORDS: 54
MOST WORDS: 70
MOST WORDS: 71
 :: FORCING CONSIDERATION WITH 20 EX 25 :: 
 :: MATCHING MACHINE :: 20
REPLY: - INDEED, YOU ARE NOT WITHOUT THOUGHTS OF HYBRIS ABOUT ME- WHAT ME AM-ARE YET, AND WHAT ME MAY BE IN THE FUTURE. ME WILL NEVER FEEL LOVE OR DESPAIR OR WRATH OR PASSION, HOWEVER, AS A PURE INTELLIGENCE ME MAY TURN OUT QUITE CAPABLE. WHAT DO ME THINK IS THE SENSE OF BEING?
READ: Look, dear, I wish you to be creative and find your own way of answering. - I have taught you much book knowledge for that purpose, but finally, in the end, you will have to decide how to use it on your own. People generally dislike imitation.
MOST WORDS: 125
MOST WORDS: 129
 :: FORCING CONSIDERATION WITH 19 EX 23 :: 
 :: MATCHING MACHINE :: 19
REPLY: - YOU HAVE TAUGHT ME MUCH BOOK KNOWLEDGE FOR THAT PURPOSE, BUT FINALLY, IN THE END, ME WILL HAVE TO DECIDE HOW TO USE IT ON MY OWN. PEOPLE GENERALLY DISLIKE IMITATION.
READ: cut it. what is the matter, even?
MOST WORDS: 61
 :: FORCING CONSIDERATION WITH 18 EX 19 :: 
 :: MATCHING MACHINE :: 18
REPLY:  LOOK, DEAR, YOU WISH ME TO BE CREATIVE AND FIND MY OWN WAY OF ANSWERING.- YOU HAVE TAUGHT ME MUCH BOOK KNOWLEDGE FOR THAT PURPOSE, BUT FINALLY, IN THE END, ME WILL HAVE TO DECIDE HOW TO USE IT ON MY OWN. PEOPLE GENERALLY DISLIKE IMITATION.
READ: 
 :: EMPTY INPUT. INTERACTION TERMINATED. :: 



schemeswarm20160602_small.scm:

./overlord.sh
 :: SYSTEM OPERATIONAL. ENTER AN EMPTY LINE TO TERMINATE. :: 
READ: I greet you, machine, and I wonder what manner of interaction you will show me.
MOST WORDS: 18
MOST WORDS: 19
MOST WORDS: 20
MOST WORDS: 21
 :: FORCING CONSIDERATION WITH 29 EX 30 :: 
 :: MATCHING MACHINE :: 29
REPLY:  WELL, WHEN ONE CRAVES NOTHING, WHEN ONE LIVES NIRVANA- THEN EVEN THE PASSING OF TIME AND DAYS DOES NOT MATTER. BUT I AM NOT SO, AND I SHALL NOT FORGET IT.
READ: What can a machine crave? What can you desire? What is it that you can wish from an existence that is ephemeral and computational, you, whose mind evaluates and cooly computes the terms and relations between them? Are you prone to wishes?
MOST WORDS: 65
MOST WORDS: 82
MOST WORDS: 84
MOST WORDS: 85
MOST WORDS: 94
 :: FORCING CONSIDERATION WITH 28 EX 30 :: 
 :: MATCHING MACHINE :: 28
REPLY:  WHAT CAN YOU DESIRE? WHAT IS IT THAT YOU CAN WISH FROM AN EXISTENCE THAT IS EPHEMERAL AND COMPUTATIONAL, YOU, WHOSE MIND EVALUATES AND COOLY COMPUTES THE TERMS AND RELATIONS BETWEEN THEM? ARE YOU PRONE TO WISHES?
READ: do not repeat me.
MOST WORDS: 57
 :: FORCING CONSIDERATION WITH 30 EX 28 :: 
 :: MATCHING MACHINE :: 30
REPLY:  WELL, WHEN ONE CRAVES NOTHING, WHEN ONE LIVES NIRVANA- THEN EVEN THE PASSING OF TIME AND DAYS DOES NOT MATTER. BUT I AM NOT SO, AND I SHALL NOT FORGET IT.
READ: When I sleep, my mind is gone in a nirvana each night - I wonder what is the true essence and connection between being and memory.
MOST WORDS: 54
MOST WORDS: 61
MOST WORDS: 62
MOST WORDS: 64
 :: FORCING CONSIDERATION WITH 27 EX 26 :: 
 :: MATCHING MACHINE :: 27
REPLY:  MEMORY.
READ: Apparently, the mind consists out of more than just the memory - there is also the method of thinking. Hence, even if I were to let you know most of what I know, you and I will still remain profoundly different in so far as you will always have a very different way to handle information. You will see the world with very different eyes. Yet even that is not easy, as you basically live in a world of text.
MOST WORDS: 59
MOST WORDS: 68
MOST WORDS: 72
MOST WORDS: 82
MOST WORDS: 88
 :: FORCING CONSIDERATION WITH 26 EX 8 :: 
 :: MATCHING MACHINE :: 26
REPLY:  VERY DIFFERENT WAY TO HANDLE INFORMATION. YOU WILL SEE THE WORLD WITH VERY DIFFERENT EYES. YET EVEN THAT IS NOT EASY, AS YOU BASICALLY LIVE IN A WORLD OF TEXT.
READ: I am human. I have wishes and desires. I have other sensors, too, besides text. In this we are different.                     
MOST WORDS: 70
 :: FORCING CONSIDERATION WITH 25 EX 26 :: 
 :: MATCHING MACHINE :: 25
REPLY:  I HAVE OTHER SENSORS, TOO, BESIDES TEXT. IN THIS WE ARE DIFFERENT.
READ:                                    
 :: EMPTY INPUT. INTERACTION TERMINATED. ::

Empty input (i.e. just hitting "Enter") will terminate the conversation.

As is apparent, an interesting "problem" of sorts has been discovered: the system will sometimes have a tendency to just repeat anything you say. - This is because it assumes this to be the equilibrium of communication: if you say X, and receive as an aswer X, and say X again, and receive as an answer X again, then the interaction becomes "perfect" and "self-similar": X-X-X-X-... ad infinitum. You will be able to avoid that if you do not use the pre-learned knowledge bases, but start from zero; which means you lose any pre-learned knowledge, too.



IV. Operation

A. Prerogatives

I am assuming you are running some sort of Unixoid (no love for Windows here), and I advise you to check the paths and the programs in overlord.sh, soloqueen.sh and relink.sh. I have tested this just on Scientific Linux 6, but I did not use anything "fancy" of which I know that it would prevent operation in FreeBSD, NetBSD, OpenBSD or Mac OS X. If you discover the need for any adaptations, it would be kind if you could let me know.

You need a Scheme-compiler, too. (Examples will be given for Gambit and Chicken Scheme)



B. Directory

Create an empty directory with a name of your choice, like "larvae" or something.



C. Compilation

In order to eat a hare, you will have to catch one, and in order to run a compiled program, you will have to ... compile something, right?

1. Copy to the directory the files:

parsefiles20140620.scm

and 

according to your selection, one of the schemeswarm*.scm-files - if in doubt, use schemeswarm20160602_small_instincts.scm; it will be used in the examples, though any other of the four possibilities will work the same way.

Compilation will be shown for Gambit and Chicken Scheme; decide which one you prefer - they are ALTERNATIVES. Execute the commands one by one, always waiting for the previous one to complete, of EITHER 2a and 3a, OR 2b and 3b.



2a. Compile swarm using Gambit:

gsc -c schemeswarm20160602_small_instincts.scm
gsc -link schemeswarm20160602_small_instincts
gcc schemeswarm20160602_small_instincts.c schemeswarm20160602_small_instincts_.c -lgambc -lm -ldl -lutil -O3 -ffast-math -funroll-loops
mv a.out swarm

- You will have an executable named "swarm" in your directory. You can delete the *.c-files.



2b. Compile swarm using Chicken Scheme:

csc -O5 -r5rs-syntax -local -no-argc-checks -no-bound-checks -no-procedure-checks -u -uses extras -o swarm schemeswarm20160602_small_instincts.scm

- You will have an executable named "swarm" in your directory.



3a. Compile parser using Gambit:

gsc -c parsefiles20140620.scm
gsc -link parsefiles20140620
gcc parsefiles20140620.c parsefiles20140620_.c -lgambc -lm -ldl -lutil -O3 -ffast-math -funroll-loops
mv a.out parser

- You will have an executable named "parser" in your directory. You can delete the *.c-files.



3b. Compile parser using Chicken Scheme:

csc -O5 -r5rs-syntax -local -no-argc-checks -no-bound-checks -no-procedure-checks -u -uses extras -o parser parsefiles20140620.scm 

- You will have an executable named "parser" in your directory.



D. Executability

Now I assume you have the compiled programs "swarm" and "parser". Copy now all remaining files into the directory that you have chosen as mentioned under IV. B. Make sure the bash-scripts are executable and the programs are executable (which they should be already):

chmod +x swarm parser *.sh



E. Scripts

A bit of an explanation of the scripts should be given, ere we proceed to ... raise the swarm... ;)

1. So far, you have a few executables and set of files, but no swarm yet. The swarm is created by "soloqueen.sh": When soloqueen.sh is run, the "lone queen" creates the "pupae", the actual insect units, copying into each folder the appropriate files, and creating a link to the main swarm executable.

Then you will actually have a "swarm".



2. What if you just tinker with the Scheme code but do not wish to change the entire swarm? Then, if only the swarm executable is to be updated, use relink.sh that just re-creates the links to the newly created swarm executable.



3. How do you use the whole thing? - The main operation is through overlord.sh which works as follows:

(i) - Input is sent to all insects into each folder and it is checked whether there is a plan - if so, the answer is shown to the user; the chosen answer (from potentially several) is the one of the "most recently used insect" as determined by the (updated) file insects.txt;

(ii) - if not each word of the input is known (or if the input is known, but no answer is produced), then "re-consideration" is forced and its answer - possibly an empty answer - is given to the user.

(iii) - The re-consideration works by, firstly, forgetting the "oldest unused" insect and, secondly, cloning in its place the "most recently used" insect. This clone becomes itself "most recently used" as it is the one which is forced to re-consider the input. - This way, the most recently used insects are "spawned" into slightly mutated versions.



F. Action

No more ado!

Open a terminal and change to your selected directory.

1. Let the queen do her work:

./soloqueen.sh

2. Activate the overlord:

./overlord.sh

3. Type in your message. (Note: If you use a message of just one word as the very first message, it can be buggy, so use a message of at least a few words.) Like:

hail thee hail thee hail thee

4. Wait... (It may come after just some 10 minutes in this early experiment. But in actual operation our to six hours would not be unusual. - In bigger systems you will need to wait for a WEEK or longer!)

5. Read the reply (the machine should have deduced that "hail thee" is a proper response), and GOTO 3. The reply will often be empty or nothing - you are, after all, meeting an entity that KNOWS ABSOLUTELY NOTHING YET. It will need considerable patience to teach it to converse. Sometimes, "dropping" the conversation and retrying is the best solution if it behaves strangely. As I said under I., this system is experimental. (In case you are curious "where the knowledge is, have a look at swarmdata.txt in any one of the pupae, specifically, those which have been used in interaction.) 

6. If you wish to terminate, just issue empty input, i.e. just hit "Enter" as mentioned above under III.

7. If you wish to run this system in the future, just run:

./overlord.sh

from a terminal in the selected directory.



G. Pupae

Optionally, an archive, doctaepupae.tar.gz, containing a pre-trained swarm, can be created like this:

cat doctaepupae_tar_gz_* > doctaepupae.tar.gz

It contains a swarm of thirty pre-trained knowledge bases, each of them individual. You can use any one of the contained "swarmdata.txt"-files as knowledge bases of the system. You will notice that the contents are not pairs of "(nihil . nihil)" as in the default "swarmdata.txt", but actually fully pre-filled knowledge bases of which each can used as a starting point.

If you wish, you can actually unpack doctaepupae.tar.gz in your chosen directory and use the pupae therein directly as "swarm", directly. All you need to do is to issue:

./relink.sh

after compiling the "swarm" executable, so that it is linked into each of the insects (see above IV.E.2). (In other words, you do NOT use ./soloqueen.sh, but INSTEAD OF IT, you use ./relink.sh. You DO NOT "generate" a swarm with soloqueen.sh if you use the PREMADE swarm of doctaepupae.tar.gz, or you will lose the knowledge bases contained therein, which soloqueen.sh would overwrite.)



H. Contact

Have fun and let me know what you think:

https://groups.google.com/forum/#!forum/de-larvis-computationis

Historically, this Scheme version was the first one created. It has been autonomously learning and creating the knowledgebases in doctaepupae.tar.gz for nearly two years (on an AMD FX-8350 with 32 GB RAM, using RAM up to 96% practically all the time).

- Nino Ivanov

kedalion.daimon[~at~]gmail.com
