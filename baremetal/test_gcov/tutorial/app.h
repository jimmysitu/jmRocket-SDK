static const unsigned char a = 'a';

static inline unsigned char *
encode (unsigned char c, unsigned char buf[2])
{
  buf[0] = c % 16 + a;
  buf[1] = (c / 16) % 16 + a;
  return buf;
}

extern void application (void);

