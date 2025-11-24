#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

versionInfo: GameID
    IFID = '5a309237-46be-db72-cd0c-d65b23c75dfb'
    name = 'Lime/Coconut'
    headline = 'A Collaborative Project'
    byline = 'Maintained by Steven Odhner'
    htmlByline = 'Maintained by <a href="mailto:sodhner@gmail.com">Steven Odhner</a>'
    authorEmail = 'Maintained by Steven Odhner <sodhner@gmail.com>'
    gameUrl = 'http://therestofyourmice.blogspot.com/p/limecoconut.html'
    desc = 'Thank you for choosing VanWink Travel!  Welcome to your destination, THE FUTURE!'
    htmlDesc = 'Thank you for choosing VanWink Travel!  Welcome to your
        destination, <i>THE FUTURE</i>!'
    version = '0.2'
    languageCode = 'en-US'
    forgivenessLevel = 'Polite'
    licenseType = 'Freeware'
    copyingRules = 'No Cost Only; Compilations Allowed'
    presentationProfile = 'Default'
    showCredit()
    {
        "The TADS 3 language and library were created by Michael J. Roberts.<.p>
        Game concept by Zoulot.<.p>
        Core design and game maintenance by Steven Odhner.<.p>
        Your current test chamber was designed by <<me.currentTest.credit>><.p>
        For full credits, go to <a
        href=http://therestofyourmice.blogspot.com/p/limecoconut.html>the game
        website</a>. ";
        "\b";
// Note that the above changes for each room.
    }
    showAbout()
    {
        "This is the pre-contest version of Lime/Coconut.  For contest details
        and updated versions of the game, please go to <a
        href=http://therestofyourmice.blogspot.com/p/limecoconut.html>the game
        website</a>. ";
    }
;

gameMain: GameMainDef
    initialPlayerChar = me
    showIntro()
    {
        "You wake up on the floor, feeling like the inventor of a new and
        powerful form of hangover.  Your memory is fuzzy but you're pleased to
        realize that you don't have some cliched case of cartoon amnesia - it's
        just some minor gaps.  There had been a fight, and you said you wanted
        to start over somewhere...<.p>
        You hear the distinctive sound of a speaker crackling and then a voice
        comes from the walls:<.p>
        \"<i>Thank you for choosing VanWink Travel!  You have
        now arrived at your destination... the future!  Due to the prolonged
        stasis you were in, we will need to do a simple test of your cognitive
        and motor skills.  Studies have shown that people of your estimated era
        enjoyed the song 'Coconut' by Harry Nilsson. So enjoy putting the 'Lime
        in de Coconut' but don't worry, you will not have to 'Drink it all
        down'.</i><.p>
        You stand up and instantly regret it as the room spins around you. 
        The last thing you can remember is signing release forms - and something
        about compounded interest?<.p>";
// Here we start the limeCleanup daemon, which will run after every turn.
        new Daemon(me, &limeCleanup, 1);
    }
    showGoodbye()
    {
        "<.p>Thanks for playing!\b";
    }
;

/* 
 *   Normally I wouldn't modify Room for something like this (the more 
 *   appropriate way if anything would be to make a new class of room), but 
 *   I want to minimize the chances that someone will send in a 
 *   non-functional test chamber.  While some of the below properties can be 
 *   passed on to other types of objects it shouldn't matter because the 
 *   game only checks them when they are part of the room that is called out 
 *   as your current test chamber.
 */

modify Room
    roomName = 'Testing Room UNDEFINED'
    desc = "This room is a perfect blank cube, white but somehow grimy. It's a
        little dusty, and the strange sourceless light seems to flicker. "
// limeCheckPoint says where this room's lime will end up when it is spawned.
    limeCheckPoint = me
// limeDesc is the spawn message.
    limeDesc = "A hole opens in the wall and a lime shoots out at you.  You deftly catch it. "
// This is the next chamber.  Nil will result in the game ending.
    nextTest = nil
// You won't have to define a lime for your room if the default will do.
    lime = lime0
// If you don't make a coconut for your room one will be generated for you.
    coconut = nil
// Insert your name to the room you make so you appear in the credits.
    credit = "UNDEFINED. "
// This is the text that displays for FULLSCORE.
    achievement : Achievement { "getting out of an improperly implemented room " }
// Here's the text for when the door opens.
    exitOpenTxt = "Part of the north wall slides open, revealing a doorway. "
/* 
 *   Text for when the door closes after being open.  Note that this is for 
 *   the exit - if you want special text about the door closing when you 
 *   first arrive, it would go in the arrivalEvent below.
 */
    exitCloseTxt = "The doorway slides shut, leaving no trace. "
// The door is always to the North.
    north = exitDoor
/* 
 *   This is something that triggers just after the player arrives in a new 
 *   room. By default it will just say that the door closes, but you can 
 *   also have it do something like start a timed event or move the door if 
 *   your area has multiple rooms.  Also, if your lime doesn't start in nil 
 *   this can be used to increase the limeCount to keep it accurate.
 */
    arrivalEvent()
    {
     "<.p>As you step through the opening, the door slides shut and vanishes
     into the wall. ";
    }
;

/* 
 *   The actor, intro, and ending may get replaced with more detailed 
 *   descriptions after the contest.  The feel of the game will change as 
 *   the rooms are submitted and put together and some attempt will be made to 
 *   have these fit in. If enough people show interest in this project then 
 *   details like this (and what XYZZY does) can be determined as a group.
 */

me: Actor
    desc = "Ten fingers, ten toes.  You feel a little shaky, maybe, but you seem to be
    in one piece. "
    currentTest = test1
    location = test1
    weight = 20
    limeCount = 0
// limeCleanup runs after every turn.
    limeCleanup()
     {
// If the lime is in the coconut, open the door.
      if (me.currentTest.lime.location == me.currentTest.coconut)
        {
         if (exitDoor.isOpen == nil)
            {
             "<.p><<me.currentTest.exitOpenTxt>> ";
             exitDoor.isOpen = true;
            }
        }
// If the lime has been destroyed, make a new one.
      else if (me.currentTest.lime.location == nil)
        {
// It takes a moment to generate a new one, just because.
         me.currentTest.lime.moveInto(limbo);
         new Fuse(me, &limeSpawner, 1);
            {
// Also, if the lime is destroyed and the door is open, close it.
             if (exitDoor.isOpen == true)
            {
             "<.p><<me.currentTest.exitCloseTxt>> ";
             exitDoor.isOpen = nil;
            }
            }
        }
// If the door is open and the lime isn't in the coconut, close the door.
        else if (exitDoor.isOpen == true)
            {
             "<.p><<me.currentTest.exitCloseTxt>> ";
             exitDoor.isOpen = nil;
            }
    }
/* 
 *   Here's how limes are made!  A few things to note... the message displays
 *   without checking to see if you can see anything so you'll have to look 
 *   into modifying the message for your room on the fly to account for this 
 *   if your test chamber includes (for example) the ability to lock 
 *   yourself in the closet.  This is true for the door opening when the 
 *   lime goes in the coconut too.  Also, see that the limeCount increases 
 *   when the lime is generated so if you use something other than the 
 *   default (lime0) you may want to start it in nil so that it increases 
 *   this number properly.
 */
    limeSpawner()
     { 
      "<.p><<me.currentTest.limeDesc>> ";
      me.currentTest.lime.moveInto(me.currentTest.limeCheckPoint);
      self.limeCount ++;
     }
;

+ jumpsuit: Wearable 'gray grey jump suit/jumpsuit' 'jumpsuit'
    "It's gray, with 'VanWink Travel' printed on the left breast. "
    weight = 0
    wornBy = me
    dobjFor(Doff)
     {
      action()
        {
         "Interestingly, there doesn't seem to be any kind of zipper or
         anything.  Hopefully if the need to use the bathroom arises you'll
         be able to figure something out. ";
        }
     }
;

+ pamphlet: Readable 'pamphlet' 'pamphlet'
// This may change, like all flavor it's just a placeholder.
    "You open the little pamphlet and read:<.p>
    <blockquote><font face='TADS-Typewriter'>
    Thank you for choosing VanWink Travel!  You have now arrived at your
    destination... the future!  If you had gone to the historical vacation
    spot of 'Hawaii' your troubles would all be waiting for you upon your return
    (and depending on your timing you may have been killed when the chain of
    islands was destroyed) but by making the brave choice to take a different
    kind of trip you have ensured a new beginning!<.p>
    While you slept, safe and secure in VanWink's cold storage facility, the
    world changed and grew into something new and exciting!  One of these new
    and exciting events destroyed VanWink's corporate headquarters, and so now
    we get to embark on this journey of discovery together!  What year did you
    go to sleep?  When had you intended to wake up?  What year is it now,
    considering the much disputed changes in calendar systems?  Nobody
    knows!*<.p>
    *<font size=1> If you do know, congratulations!  Your neurological damage is
    less than typical!\"<.p></font></font></blockquote>
    This sounds familiar enough.  It had seemed like a good idea at the time."
    weight = 0
    bulk = 0
;

// limbo is so limes don't generate while they're waiting to generate.
limbo: Room 'Holding Area'
    "This room is just a work-around to keep things in if we don't want them in
    nil but we also don't want them available to the player.  This wouldn't
    normally be needed except for the dumb way I'm doing things. Anyway, if
    you're reading this in-game someone messed up."
;

// There's only one door, but it moves to each room with you.
exitDoor : HiddenDoor 'door/doorway/opening' 'doorway' 
    "A section of the north wall has moved aside, revealing a doorway. "
  specialDesc = "A section of the north wall has moved aside, revealing a doorway. "
  useSpecialDesc { return self.isOpen || useInitSpecialDesc(); }
// This leads to the room it's already in until you try to walk through it.
  destination = me.currentTest
  dobjFor(TravelVia)
    {
        action()
        {
            {
// Just a quick fix to keep other actors from using the door. May not always be grammatical.
             if(gActor != me)
                    {
                    "The door slams shut, and opens again once they back away. ";
                    exit;
                    }
                /* 
 *   If the player weighs more than they should they can't leave. Note that 
 *   the default weight of all items is 1, so anything at all will keep them 
 *   from leaving.  If for some reason you set the weight for something to 0 
 *   (like the pamphlet above) the player will be able to cart it around.  
 *   If that pamphlet causes trouble for you it can be removed but it's 
 *   probably best to account for the possibility that 0-weight items will 
 *   show up from other areas.
 */
             if(me.getWeight != 20)
                {
                 "As you walk towards the door it slams shut, and a recorded
                 message plays. \b
                  \"<i>Please do not take any items from the testing area. 
                 Thank you for your cooperation!</i>\" \b
                  You take a step back and the door slides open again.";
                 exit;
                }
            }
// Increase the score every time they make it out of a room.
         me.currentTest.achievement.addToScoreOnce(1);
// If there's no next chamber they win the game.
         if (me.currentTest.nextTest == nil)
            {
             "You step through the doorway only to find yourself somewhere
             pleasant.  I don't know, a beach or something.  Whatever. ";
             finishGameMsg(ftVictory, [finishOptionUndo,finishOptionFullScore]);
            }
         else
            {
// Update what chamber we're on.
             me.currentTest = me.currentTest.nextTest;
// Prep lime0 in case it's needed.
             lime0.moveInto(nil);
// If there's no coconut item defined, make one.
             if (me.currentTest.coconut == nil)
                {
                 me.currentTest.coconut = new Coconut;
                }
// Actually go through the door.
             inherited();
             gActor.rememberLastDoor(self);
// And reset for the next room!
             isOpen = nil;
             exitDoor.moveInto(me.currentTest);
// Trigger entry message.
             me.currentTest.arrivalEvent();
            }
        }
    }
  travelBarrier = [exitBarrier]
  location = test1
;

// This should keep the player from shoving things into the next room.
exitBarrier : PushTravelBarrier
  explainTravelBarrier(traveler)
     {
         local obj = traveler.obj_;
         gMessageParams(obj);
         reportFailure('As you walk towards the door it slams shut, and a
             recorded message plays. \b
                       \"<i>Please do not take any items from the testing area.
             Thank you for your cooperation!</i>\" \b
                       You pull {the obj/he} back and it opens again. ');
     }
;

/* 
 *   This is the default lime. You can define your own so that it has special
 *   properties when thrown or whatever.  It might be a good idea to keep 
 *   the limecount stenciled on for fun, and I would recommend starting it 
 *   out in nil so that the limecount is increased when the player enters 
 *   the room.  Originally I made it so each room's 'lime' item was dropped 
 *   into nil automatically as the player entered, but as much as I want the 
 *   limecount to stay accurate I figured I wouldn't force it since you may 
 *   want your lime to be already present but inaccessible or something.
 */
lime0: Food 'lime' 'lime'
    "A healthy-looking lime. The number <<me.limeCount>> is stenciled on it. "
;

/* 
 *   This is the default coconut.  I made it as a class because it's easier 
 *   for me to make a new one as needed than to make sure a reusable one 
 *   isn't carting things around with it.  I found myself writing code to 
 *   empty it out between rooms and realized this was actually way easier on 
 *   me.
 */
class Coconut: Container, Immovable 'fake coconut' 'coconut'
    "It's the standard fake coconut with a hole in the top. "
    cannotTakeMsg = 'It seems to be firmly attached somehow. '
    isListed = true
    isListedInContents = true
    location = me.currentTest
;

// Test Chamber One

test1: Room 'Testing Room 1'
    "There's a stale smell to the air, making you think of a waiting room. 
    Unlike a waiting room, however, there are no chairs or coffee maker.  In
    fact, there's not much at all other than a poster on the wall and a small
    table. "
    limeCheckPoint = table1
    limeDesc = "A hole opens in the ceiling and a lime drops out onto the table.
        The hole closes back up seamlessly."
    nextTest = test2
    coconut = coconut1
    credit = "Steven Odhner. "
    achievement : Achievement { "putting a lime in a coconut " }
    /* 
     *   There's no need to define an exit because that's in the default Room
     *   definition.  Likewise, there's no lime specifically defined for 
     *   this room.  They did define a coconut, because the default coconut 
     *   ends up on the floor and they wanted this one on the table.
     */
;

+ poster1: Decoration 'poster' 'poster'
    "There's a picture of a smiling man giving a thumbs-up, and the caption:
    \"Because in the future, everyone you hate is already dead!\" "
;

+ table1: Surface, Fixture 'table' 'table'
    "This is a simple metal table. "
;

++ coconut1: Container, Immovable 'fake coconut' 'coconut'
    "Upon closer inspection this coconut is fake and is attached to the
    table. There is a hole in the top. "
    cannotTakeMsg = 'It seems to be firmly attached somehow. '
    isListed = true
    isListedInContents = true
;

// Test Chamber Two

test2: Room 'Testing Room 2'
    "Another plain white room, this time without a table. A white box sits
    conspicuously in one corner. "
    limeCheckPoint = test2
    limeDesc = "A hole opens in the ceiling and a lime drops out onto the floor.
        The hole closes back up seamlessly."
    nextTest = test3
    coconut = coconut2
    credit = "Steven Odhner. "
    achievement : Achievement { "putting a lime in a coconut in a box " }
// Here's a modified arrivalEvent:
    arrivalEvent()
    {
     "<.p>As you step through the opening, the door slides shut.  It's a little
     too eager and catches your heel for a second, making you stumble. ";
    }
;

/* 
 *   To avoid conflicting object names as rooms are added, it is best to have
 *   the room number on the end of each item.  As the rooms are put in 
 *   order I'll just replace the number with the correct one and slap them in.
 */

+ box2: OpenableContainer, Fixture 'plain white box' 'box'
    "It's a plain white box. "
;

++ coconut2: Container, Immovable 'fake coconut' 'coconut'
    "It's another fake coconut, with an open top. "
    cannotTakeMsg = 'It seems to be firmly attached somehow. '
    isListed = true
    isListedInContents = true
;

// Test Chamber Three

test3: Room
;

/* 
 *   Note that because the Room definition was changed the above blank test 
 *   chamber will work just fine.  When testing entries I will delete the 
 *   above and replace it with the code that is sent in.  I won't touch 
 *   anything above the "Test Chamber Three" note.  The two 'real' test 
 *   chambers in this file don't do much, but I promise there's a lot of 
 *   possibilities. Remember that the room properties can be changed on the 
 *   fly, so the limeCheckPoint can start out as nil (meaning the limes 
 *   generate and are destroyed over and over) and then change to something 
 *   else when the player, for example, puts the lid on the vat of acid.  
 *   Get as creative as you can without breaking it, and don't be afraid to 
 *   add story / plot / flavor elements as well.  Knock yourself out.
 */