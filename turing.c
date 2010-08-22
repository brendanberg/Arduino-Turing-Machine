#include "turing.h"
#include <string.h>
#include <stdlib.h>

// Allocate memory for machine m

machine * machine_alloc() {
  return calloc(sizeof(machine), 1);
}

void machine_create(machine **m) {
  *m = calloc(sizeof(machine), 1);
}


// Deallocate memory for machine m

void machine_destroy(machine *m) {
  free(m);
}


// Step the machine for the current head state

int machine_step(machine *m, head *h) {
  if (h->current == m->final) return 0;
  
  transition *t, **tr = m->transitions;
  while (*tr != 0) {
    t = *tr;
    if (t->initial == h->current && t->symbol == *(h->tape + h->position)) {
      *(h->tape + h->position) = t->replacement;
      h->position += t->direction;
      h->current = t->next;
      break;
    }
    tr++;
  }
  
  return 1;
}



// Allocate memory for transition t

void transition_create(transition **t) {
  *t = calloc(sizeof(transition), 1);
}


// Recursively deallocate memory for transition t

void transition_destroy(transition *t) {
  free(t);
}


// Initialize transition t with argument values

void transition_init(transition *t, state *initial, char symbol, char replacement, char direction, state *next) {
  t->initial = initial;
  t->symbol = symbol;
  t->replacement = replacement;
  t->direction = direction;
  t->next = next;
}


// Allocate memory for state s

void state_create(state **s, char *name) {
  state *new = calloc(sizeof(state), 1);
  
  if (name) {
    new->name = calloc(sizeof(char), strlen(name) + 1);
    strcpy(new->name, name);
  }
  
  *s = new;
}


// Recursively deallocate memory for state s

void state_destroy(state *s) {
  if (s->name) {
    free(s->name);
  }

  free(s);
}



// Allocate memory for head h

head * head_alloc() {
  return calloc(sizeof(head), 1);
}

void head_create(head **h) {
  *h = calloc(sizeof(head), 1);
}


// Recursively deallocate memory for head h

void head_destroy(head *h) {
  if (h->tape) {
    free(h->tape);
  }

  free(h);
}

