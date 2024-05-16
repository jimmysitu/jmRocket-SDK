## Test GCOV



## Official Tutorial
[Profiling and Test Coverage in Freestanding Environments](https://gcc.gnu.org/onlinedocs/gcc/Freestanding-Environments.html)
- Support by GCC 13.2.0 or above

### Overview
The tutorial example prints gcov info stream to STDOUT (bin format) and  STDERR (string format)

The stream to STDOUT is piped to `gcov-tool merge-stream`, which can merge the gcov info to the relative .gcda files

`gcov-tool merge-stream` need to feed with gcfn stream and gcda stream.
Both streams are variable-length byte stream ending with '\0'.

It seems it is safe to append '\0' to the streams if they are fetch from a binrary file




