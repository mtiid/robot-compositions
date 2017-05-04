
FileIO fin;
fin.open(me.arg(0));

if(!fin.good()) {
    cherr <= "unable to open input file '" <= me.arg(0) <= "'\n";
    me.exit();
}

OscOut oout;
oout.dest("chuckServer.local", 50000);

float last;

while(fin.more()) {
    
    float t;
    int data1, data2, data3;

    fin => t;
    fin => data1;
    fin => data2;
    fin => data3;
    
    if(t-last > 0) {
        (t-last)::second => now;
        t => last;
    }
    
    <<< data1, data2, data3 >>>;
    
    handleMidi(data1, data2, data3);
}

fun void handleMidi(int data1, int data2, int data3) {
    (data1 & 0xF0)>>4 => int status; // midi status byte
    (data1 & 0x0F) => int chan;      // midi channel
    if(status==9){ // note on
        data2 => int noteNum;
        data3 => int vel;
        if(chan==0){ // maha devi
            if(noteNum > 59 & noteNum < 74){
                oout.start("/devibot");
                oscOut(noteNum, vel);
                <<< "/devibot", noteNum - 60, vel >>>;
            }
        }
        if(chan==1){ // gana pati
            if(noteNum > 59 & noteNum < 81){
                oout.start("/ganapati");
                oscOut(noteNum, vel);
                <<< "/ganapati", noteNum - 60, vel >>>;
            }
        }
        if(chan==2){ // breakbot
            if(noteNum > 59 & noteNum < 86){
                oout.start("/drumBot");
                oscOut(noteNum, vel);
                <<< "/drumBot", noteNum - 60, vel >>>;
            }
        }
        if(chan==3){ // clappers
            if(noteNum>59 & noteNum<81){
                oout.start("/clappers");
                oscOut(noteNum, vel);
                <<< "/clappers", noteNum - 60, vel >>>;
            }
        }
        if(chan==4){ // jackbox percussion
            if(noteNum>59 & noteNum<100){
                oout.start("/jackperc");
                oscOut(noteNum, vel);
                <<< "/jackperc", noteNum - 60, vel >>>;
            }
        }
        if(chan==5){ // jackbox bass
            if(noteNum>59-8 & noteNum<84-8){
                oout.start("/jackbass");
                oscOut(noteNum + 8, vel);
                <<< "/jackbass", noteNum + 8 - 60 >>>;
            }
        }
        if(chan==6){ // jackbox guitar
            if(noteNum>59-8 & noteNum<94-8){
                oout.start("/jackgtr");
                oscOut(noteNum + 8, vel);
                <<< "/jackgtr", noteNum + 8 - 60, vel >>>;
            }
        }
        if(chan==7){ // MDarimBot
            oout.start("/marimba");
            serialOscOut(noteNum, vel);
            <<< "/marimba", noteNum, vel >>>;
        }
        if(chan==8){ // Trimpbeat
            // allow for 60+ midi notes to work
            // for consistancy
            oout.start("/trimpbeat");
            serialOscOut(noteNum, vel);
            <<< "/trimpbeat", noteNum, vel >>>;
        }
        if(chan==9){ // Trimpspin
            oout.start("/trimpspin");
            serialOscOut(noteNum, vel);
            <<< "/trimpspin", noteNum, vel >>>;
        }
        if(chan==10){ // StringThing 
            oout.start("/stringthing");
            serialOscOut(noteNum, vel);
            <<< "/stringthing", noteNum, vel >>>;
        }
        if(chan==12){ // RattleTron
            oout.start("/rattletron");
            serialOscOut(noteNum, vel);
            <<< "/rattletron", noteNum, vel >>>;
        }
        if(chan==13){ // BlowBot
            oout.start("/blowbot");
            serialOscOut(noteNum, vel);
            <<< "/blowbot", noteNum, vel >>>;
        }
        if(chan==11){ // Snapperbots
            if (noteNum < 4){
                oout.start("/snapperbot1");
                serialOscOut(noteNum, vel);
                <<< "/snapperbot1", noteNum, vel >>>;
            }
            else if (noteNum < 8){
                oout.start("/snapperbot2");
                serialOscOut(noteNum, vel);
                <<< "/snapperbot2", noteNum, vel >>>;
            }
            else if (noteNum < 12){
                oout.start("/snapperbot3");
                serialOscOut(noteNum, vel);
                <<< "/snapperbot3", noteNum, vel >>>;
            }
            else if (noteNum < 16){
                oout.start("/snapperbot4");
                serialOscOut(noteNum, vel);
                <<< "/snapperbot4", noteNum, vel >>>;
            }
            else if (noteNum < 20){
                oout.start("/snapperbot5");
                serialOscOut(noteNum, vel);
                <<< "/snapperbot5", noteNum, vel >>>;
            }
            else if (noteNum < 24){
                oout.start("/snapperbot6");
                serialOscOut(noteNum, vel);
                <<< "/snapperbot6", noteNum, vel >>>;
            }
        }
    }
    if(status==8){ // note off
        data2 => int noteNum;
        if(chan==5){ // jackbox bass
            if(noteNum>59-8 & noteNum<84-8){
                oout.start("/jackbass");
                oscOut(noteNum + 8, 0);
                // xmit.startMsg("/jackbass,ii");
            }
        }
        if(chan==6){ // jackbox guitar
            if(noteNum>59-8 & noteNum<94-8){
                oout.start("/jackgtr");
                oscOut(noteNum + 8, 0);
            }
        }
        if(chan==9){ //Trimpspin
            oout.start("/trimpspin");
            oscOut(noteNum, 0);
        }
    }
}

fun void serialOscOut(int newNoteNum, int newVel){
    oout.add(newNoteNum);
    oout.add(newVel);
    oout.send();
}

fun void oscOut(int newNoteNum, int newVel){
    oout.add(newNoteNum - 60);
    oout.add(newVel);
    oout.send();
}
