// SimpleMidi.pde

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 
import processing.sound.*;

TriOsc triOsc;
Env env; 
Reverb reverb;
Reverb reverb2;
Delay delay;
Delay delay2;
SinOsc sine;
SoundFile soundfile;
LowPass lowPass;
HighPass highPass;
BandPass filter;

MidiBus myBus; 

int currentColor = 0;
int midiDevice  = 3;
int velo;
int velo2;
int velo3;
int velo4;
int velo5;
int velo6;
int velo7;
int velo8;
int valueo2;
int beatk2;
int beatk3;
int beatk4;
int beatk5;
int nota;
int pitch;
//int vel2;
boolean b;

// Play a new note every 200ms
int duration = 200;

// This variable stores the point in time when the next note should be triggered
int trigger = millis(); 

// An index to count up the notes
int note = 0;

void setup() {
  size(500, 500);
  //background(200);
  MidiBus.list(); 
  myBus = new MidiBus(this, 1, 1); 
    // Create triangle wave and start it
   // triOsc no draw if k>1 triOsc= new SinOsc(This);
  triOsc = new TriOsc(this);
  //posso armazenar o tipo de informaçao do ocilador numa variavel? qua seria o tipo?

  // Create the envelope 
  env = new Env(this);
  
    // Create the effect object
  reverb = new Reverb(this);

  // Set soundfile as input to the reverb 
  reverb.process(triOsc);

  // Create the delay effect
  delay = new Delay(this);

  // Connect the soundfile to the delay unit, which is initiated with a
  // five second "tape"
  delay.process(triOsc,0.4);
  
    // Load a soundfile
  soundfile = new SoundFile(this, "beat6.wav");

  // Play the file in a loop
  soundfile.loop();
  
  //lowPass = new LowPass(this);
  
  //lowPass.process(soundfile);

 // highPass = new HighPass(this);

  //highPass.process(soundfile);
  
    reverb2 = new Reverb(this);

  // Set soundfile as input to the reverb 
  reverb2.process(soundfile);
  
  filter = new BandPass(this);

  filter.process(soundfile);
}

void draw() {
  int channel=0;
  int number=0;
  int value=90;
  // o midi manda apenas as variaveis, não o som, então fica a meu quesito
  //qual som eu poderei controlaer com as variáveis do midi
  //juntar com as coisas do projeto "sequencia_controlada", por a sequencia 
  //de notas midi para ser determinada pela variavel pitch que por sua vez
  //corresponderá as notas emitidas pelo pad
  
  //vel será as variaveis de efeito
  
  //o knob 1 que mata o som,e sua variavel "velo" podem ser utilizados
  //para um esquema de troca de timbre: fazer um variavel "timbre"que se "velo" for>60
  //ela se tornre "Saw" e se for<60 se torne "Sine". assim alternando o timbre 
  //de acordo com o numero da variavel
      
  int[] midiSequence = { nota, nota, nota ,nota, nota, nota, nota, nota, nota, nota };
//k1-para,mudança de modo, k-2 tempo entre notas, k-4 reverb
  
  
 //mapeia os valores do knob e os convert para valores mais amplos, depois
 //converte esses valores para variavel int
 //aqui se organiza o e squema de duracao entre notas atribuido ao knob 2
 float duracao= map(velo2,0,127,60,700);
 int dur = int(duracao);
 int duration = dur;
 
 //reverb
  float reve = float(velo4);
  float effectStrength = map(reve, 0, 127, 0, 0.50);
  reverb.wet(effectStrength);

  // delay
  float delayo = float(velo8);
  float fb = map(delayo, 0, 127, 0.0, 0.4);
  delay.feedback(fb);
  
    // Delay
  float delaytempo = float(velo7);
  float delayTime = map(delaytempo, 0, 127, 0.001, 2.0);
  delay.time(delayTime);

  //Delay beat
 // float delay2tempo = float(velo);
 // float delay2Time = map(delay2tempo, 0, 127, 0.009, 0.6);
 // delay2.time(delay2Time);


  //amplitude
  float amplitude = float(velo3);
  float amply = map(amplitude, 0, 127, 0.5, -0.5);
  triOsc.amp(amply);
 
 //ADSR:Attack
 float ataque = float(velo5);
 float attackTime = map(ataque,0,127,0.001,0.5);
 
  //ADSR:sustain
 //float sustento = float(velo6);
 //float sustainTime = map(sustento,0,127,0.001,0.6);
 
   //ADSR:sustain
 float soltura = float(velo6);
 float releaseTime = map(soltura,0,127,0.001,0.5);
 
 //ADSR fixos
float sustainTime = 0.08;
float sustainLevel = 0.3;
//float releaseTime = 0.2; 

//----Efeitos do beat--------------------

 //Lowpass beat
 // float low = float(beatk2);
 // float cutoff = map(low, 0, 127, 800, 8000);
 // lowPass.freq(cutoff);
  
 //highpass beat
   //float high = float(beatk2);
 //  float cutoffh = map(high, 0, 127, 50, 4000);
  // highPass.freq(cutoffh);
  
  //reverb beat
    float reveb = float(beatk5);
    float effectStre = map(reveb, 0, 254, 0, 1.0);
  reverb.damp(effectStre);
  
  //bandpass beat
  float freq = float(beatk3);
  float frequency = map(freq, 0, 127, 20, 8000);
  // And the vertical mouse position to the width of the band to be passed through
  float bandw = float(beatk4);
  float bandwidth = map(bandw, 0, 127, 1000, 100);

  filter.freq(frequency);
  filter.bw(bandwidth);

  float amplitudebeat = float(beatk2);
  float amplybeat = map(amplitudebeat, 0, 254, 1.0, -0.9);
  soundfile.amp(amplybeat);

 // float effectStrength = map(mouseY, 0, height, 0, 1.0);
  //reverb.wet(effectStrength);
  // If the determined trigger moment in time matches up with the computer clock and
  // the sequence of notes hasn't been finished yet, the next note gets played.
  if ((millis() > trigger) && (note<midiSequence.length)) {

    // midiToFreq transforms the MIDI value into a frequency in Hz which we use to
    // control the triangle oscillator with an amplitute of 0.5
    triOsc.play(midiToFreq(midiSequence[note]), 0.5);

    // The envelope gets triggered with the oscillator as input and the times and
    // levels we defined earlier
    env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);

    // Create the new trigger according to predefined duration
    trigger = millis() + duration;

    // Advance by one note in the midiSequence;
    note++; 
        if (note == 10) {
      note = 0;
    }
  
  background(currentColor,200,200);
  rect(velo,10,100,100); 
  fill(random(255), random(255), random(255), 100);
  rect(velo2,10,200,100);
 // fill(random(255), random(255), random(255), 100);
  rect(velo3,10,250,250); 
  fill(random(255), random(255), random(255), 100);
  rect(velo4,10,100,100);
  rect(velo5,350,50,150); 
  fill(random(255), random(255), random(255), 100);
  rect(velo6,350,50,150);
  rect(velo7,400,200,200); 
  fill(random(255), random(255), random(255), 100);
  rect(velo8,400,200,200);

  
  
   myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  delay(2);}
  
  //adaptar as variaveis do controller change pros meus designos
  //substituir note por number para designar os knobs
}

void midiMessage(MidiMessage message, long timestamp, String bus_name) { 
  int note = (int)(message.getMessage()[1] & 0xFF) ;
  int number = (int)(message.getMessage()[1] & 0xFF) ;
  int vel = (int)(message.getMessage()[2] & 0xFF);
  int vel2 = (int)(message.getMessage()[2] & 0xFF);
  int vel3 = (int)(message.getMessage()[2] & 0xFF);
  int vel4 = (int)(message.getMessage()[2] & 0xFF);
  int vel5 = (int)(message.getMessage()[2] & 0xFF);
  int vel6 = (int)(message.getMessage()[2] & 0xFF);
  int vel7 = (int)(message.getMessage()[2] & 0xFF);
  int vel8 = (int)(message.getMessage()[2] & 0xFF);
  int value2 = (int)(message.getMessage()[2] & 0xFF);
  
    
  println("Bus " + bus_name + ": Note "+ note + ", vel " + vel);
  if (vel > 0 ) {
   currentColor = vel*2;
  }

  if (number==1)
  {
    velo = vel*2;

  }
  if (number==2 ) {
    //vel=vel2;
    if(key=='r')
    {
    beatk2 = vel2*2;
    println(beatk2);
    }
    else
    {
    velo2 = vel2*2;  
    }
  }
    if (number==3)
  {
       if(key=='r')
    {
    beatk3 = vel3;
    println(beatk3);
    }
    else
    {
    velo3 = vel3;  
    }

  }
  if (number==4 ) {
       if(key=='r')
    {
    beatk4 = vel4;
    println(beatk4);
    }
    else
    {
    velo4 = vel4;  
    }
  }
    if (number==5)
  {
       if(key=='r')
    {
    beatk5 = vel5;
    println(beatk5);
    }
    else
    {
    velo5 = vel5;  
    }
  }
  if (number==6 ) {
    //vel=vel2;
    velo6 = vel6*2;
  }
    if (number==7)
  {
    velo7 = vel7*2;

  }
  if (number==8 ) {
    //vel=vel2;
    velo8 = vel8*2;
  }
  if(note>9) {
    nota=note;
}
  if(note==1) {
    nota=0;
  } 
   
    //usar somente um dos knobs para zerar a variavel nota o -knob 1
    //inventar uma variavel q de conta das mudanças de pitch de cada nota
    //mapear os valores de note q aparecem qdo a nota no pad eh apertada para isso
//57, 59, 61, 62, 64, 66, 68, 69-valores do pitch, encontrar um jeito de
// mecher no knob sem matar a nota, somar a variavel "vel" ao pitch pra poder
//fazer algo dinamico estilo DJ
if(note>9)
{
 pitch=note;
}
if(note<9){
  pitch=velo8;
}
  println("nota " + nota + ": pitch "+ pitch);
  
}
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}
