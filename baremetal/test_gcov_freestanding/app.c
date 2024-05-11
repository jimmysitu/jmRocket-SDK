#include "app.h"

#include <stdio.h>

/* The application reads a character stream encoded by encode() from stdin,
   decodes it, and writes the decoded characters to stdout.  Characters other
   than the 16 characters 'a' to 'p' are ignored.  */

static int can_decode (unsigned char c)
{
  return (unsigned char)(c - a) < 16;
}

void
application (void)
{
  int first = 1;
  int i;
  unsigned char c;

  while ((i = fgetc (stdin)) != EOF)
    {
      unsigned char x = (unsigned char)i;

      if (can_decode (x))
        {
          if (first)
            c = x - a;
          else
            fputc (c + 16 * (x - a), stdout);
          first = !first;
        }
      else
        first = 1;
    }
}

