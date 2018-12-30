// SimpleMidi.pde

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; 
import processing.sound.*;

TriOsc triOsc;
Env env; 
Reverb reverb;

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
int nota;
int pitch;
//int vel2;
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.2; 

// Play a new note every 200ms
int duration = 200;

// This variable stores the point in time when the next note should be triggered
int trigger = millis(); 

// An index to count up the notes
int note = 0;

void setup() {
  size(480, 320);
  //background(200);
  MidiBus.list(); 
  myBus = new MidiBus(this, 1, 1); 
    // Create triangle wave and start it
  triOsc = new TriOsc(this);

  // Create the envelope 
  env = new Env(this);
  
    // Create the effect object
  reverb = new Reverb(this);

  // Set soundfile as input to the reverb 
  reverb.process(triOsc);
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
  
 //mapeia os valores do knob e os convert para valores mais amplos, depois
 //converte esses valores para variavel int
 //aqui se organiza o esquema de duracao entre notas atribuido ao knob 2
 float duracao= map(velo2,0,127,60,500);
 int dur = int(duracao);
 int duration = dur;
 
   // Change the roomsize of the reverb
   float reve = float(velo4);
  float effectStrength = map(reve, 0, 127, 0, 0.50);
  reverb.wet(effectStrength);
 // println(roomSize);

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
  rect(velo,10,10,10); 
  rect(velo2,10,10,10);
  rect(velo3,10,10,10); 
  rect(velo4,10,10,10);
  rect(velo5,10,10,10); 
  rect(velo6,10,10,10);
  rect(velo7,10,10,10); 
  rect(velo8,10,10,10);

  
  
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
    velo2 = vel2*2;
    valueo2 = value2*2;
  }
    if (number==3)
  {
    velo3 = vel3*2;

  }
  if (number==4 ) {
    //vel=vel2;
    velo4 = vel4*2;
  }
    if (number==5)
  {
    velo5 = vel5*2;

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
