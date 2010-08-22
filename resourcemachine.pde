#include "turing.h"

int ledPin =  13;    // LED connected to digital pin 13

machine *m;
state *q0, *q1, *q2, *q3, *q4, *q5, *qF;
transition *t0, *t1, *t2, *t3, *t4, *t5, *t6, *t7, *t8, *t9;
head *h;

int cont = 1;

// The setup() method runs once, when the sketch starts

void setup() {
  
  m = machine_alloc();
  
  state_create(&q0, "q0");
  state_create(&q1, "q1");
  state_create(&q2, "q2");
  state_create(&q3, "q3");
  state_create(&q4, "q4");
  state_create(&q5, "q5");
  state_create(&qF, "qF");
  
  transition_create(&t0);
  transition_init(t0, q0, 'l', 'l', 1, q0);
  
  transition_create(&t1);
  transition_init(t1, q0, 'o', 'o', 1, q1);
  
  transition_create(&t2);
  transition_init(t2, q1, 'o', 'o', 1, q2);
  
  transition_create(&t3);
  transition_init(t3, q2, 'p', 'p', 1, qF);
  
  transition_create(&t4);
  transition_init(t4, q2, 'o', 'o', 1, q3);
  
  transition_create(&t5);
  transition_init(t5, q3, 'o', 'o', 1, q3);
  
  transition_create(&t6);
  transition_init(t6, q3, 'p', ' ', -1, q4);
  
  transition_create(&t7);
  transition_init(t7, q4, 'o', 'p', -1, q5);
  
  transition_create(&t8);
  transition_init(t8, q5, 'o', 'o', -1, q5);
  
  transition_create(&t9);
  transition_init(t9, q5, 'l', 'l', 1, q0);
  
  m->initial = q0;
  m->final = qF;
  m->transitions = (transition**)calloc(sizeof(transition*), 11);
  m->transitions[0] = t0;
  m->transitions[1] = t1;
  m->transitions[2] = t2;
  m->transitions[3] = t3;
  m->transitions[4] = t4;
  m->transitions[5] = t5;
  m->transitions[6] = t6;
  m->transitions[7] = t7;
  m->transitions[8] = t8;
  m->transitions[9] = t9;

  m->inputSymbols = "lop";
  m->blank = ' ';
  
  h = head_alloc();
  h->current = q0;
  char *t = "loooooooop";
  h->tape = (char *)calloc(sizeof(char), strlen(t) + 1);
  strcpy(h->tape, t);
  h->position = 0;
  
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop() {
  digitalWrite(ledPin, HIGH);
  delay(50);
  digitalWrite(ledPin, LOW);
  
  if (cont) {
    //printf("%s: %s\n", h->current->name, h->tape);
    Serial.write(h->current->name);
    Serial.write(": ");
    Serial.write(h->tape);
    Serial.write("\n");
    
    char *pos = (char *)malloc(sizeof(char) * h->position + 2);
    int i;
    for (i = 0; i < h->position; i++) {
      *(pos + i) = ' ';
    }
    *(pos + h->position) = '^';
    *(pos + h->position + 1) = 0;
    
    //printf("    %s\n", pos);
    Serial.write("    ");
    Serial.write(pos);
    Serial.write("\n\n");
    
    free(pos);
  } else {
    delay(5000);
  }
  
  cont = machine_step(m, h);
}

