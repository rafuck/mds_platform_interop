#include <stdint.h>
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t
native_inc(int32_t x)
{
    return ++x;
}