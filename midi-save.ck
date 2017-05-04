
MidiIn min;
MidiMsg msg;

if(!min.open("IAC")) {
    cherr <= "error: unable to open midi device\n";
    me.exit();
}

FileIO fio;
fio.open(me.arg(0), FileIO.WRITE);

if(!fio.good()) {
    cherr <= "error: unable to open output file '" <= me.arg(0) <= "'\n";
    me.exit();
}

0 => int started;
time startTime;

while(true) {
    min => now;
    
    while(min.recv(msg)) {
        if(!started) {
            1 => started;
            now => startTime;
        }
        
        // time data1 data2 data3
        fio <= (now-startTime)/second <= " ";
        fio <= msg.data1 <= " " <= msg.data2 <= " " <= msg.data3;
        fio <= IO.nl();
    }
    
    fio.flush();
}
