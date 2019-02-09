#include "common.h"

#define LINE_COUNT 25
#define LINE_LENGTH 80
#define COLOR 0x04

static unsigned short *display_buf = (unsigned short *) 0xb8000;
static const unsigned short char_attr = COLOR << 8;

static unsigned char cursor_x = 0;
static unsigned char cursor_y = 0;
void asm_hlt(){
	_asm();
}
void cleanf()
{
	unsigned int i;
	for (i = 0; i < LINE_COUNT * LINE_LENGTH; i++)
	{
		display_buf[i] = 0x20 | char_attr;
	}

	cursor_x = 0;
	cursor_y = 0;
}

static void scroll()
{
	if (cursor_y >= LINE_COUNT)
	{
		unsigned int i;
		for (i = 0; i < (LINE_COUNT - 1) * LINE_LENGTH; i++)
		{
			display_buf[i] = display_buf[i + LINE_LENGTH];
		}

		for (i = (LINE_COUNT - 1) * LINE_LENGTH; i < LINE_COUNT * LINE_LENGTH; i++)
		{
			display_buf[i] = 0x20 | char_attr;
		}
		cursor_y = 24;
	}
}

void _printf(const char c)
{
	if (c >= ' ')
	{
		display_buf[cursor_y * LINE_LENGTH + cursor_x] = c | char_attr;
		cursor_x++;
	}
	else
	{
		cursor_x = 0;
		cursor_y++;
	}

	// 每行80个字符，满80个字符换行
	if (cursor_x >= 80)
	{
		cursor_x = 0;
		cursor_y++;
	}

	scroll();
}

void printf(const char* str)
{
	while (*str)
	{
		_printf(*str++);
	}
}


