# Ctrl + Z Counter

## What is this exactly?
Essentially a program that counts the times you undo an action in any drawing, design, modeling, etc. app.
It hooks the keyboard to globally listen to the Ctrl + Z combination, as of right now, without process filtering. 
I... kind of overdid this. You will understand why after you see the list of features.

## Inspiration
Oh well... I have an artist friend. This friend in particular is pretty good at drawing almost everything; his style is cute, too. But... the times he undoes a single line in a single second is kind of scary. Ever since we saw him draw something seriously, we made fun of him (in a friendly way) because of that. I won't say much more, but i ended up offering myself to make a program that would count how many times he used Ctrl + Z. So here we are!

This is actually the second iteration of the program... The first was actually a mess. Written in C++ and using wxWidgets! I never actually made the UI for it because i was just terrible at programming in a language other than JavaScript, and my C++ setup was just terrible. I had no idea how to fix my errors and i gave up; we are talking about 9, almost 10 months ago.
Nowadays, i'm more capable of programming in general; not just javascript. Let's say... i allowed myself to just learn and do, instead of hoping i learn something without actually trying it.

## When did i start this project?
I started learning Flutter and making this program on March 1, 2025. 

## Features
- System-wide key listener
- Total click count for a session
- Today's click count for a session
- Total click count for a specific day (using a date picker)
- Session list
- Session status (did you finish your drawing?)
- Discord RPC
- Material You 3 UI
- Light and Dark mode
- Custom background image support (GIF support out of the box)
- Background color palette generation
- Random color selector (will replace with Material You color palette)
- Silly finish animation (you will see for yourself)
