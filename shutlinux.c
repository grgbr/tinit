#include <unistd.h>
#include <stdio.h>	/* puts */
#include <time.h>	/* nanosleep */
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/reboot.h>

static void do_reboot(void)
{
	reboot(RB_AUTOBOOT);
}
static void do_poweroff(void)
{
	reboot(RB_POWER_OFF);
}
static void do_halt(void)
{
	reboot(RB_HALT_SYSTEM);
}

static void usage(void)
{
	puts(
	    "Usage: shutlinux -h|-r|-p [NN]\n"
	    "	NN - seconds to sleep before requested action"
	);
	exit(1);
}

enum action_t {
	SHUTDOWN,	// do nothing
	HALT,
	POWEROFF,
	REBOOT
};

int main(int argc, char *argv[])
{
	struct timespec t = {0,0};
	enum action_t action = SHUTDOWN;
	int c, i;
	char *prog, *ptr;

	//if (*argv[0] == '-') argv[0]++; /* allow shutdown as login shell */
	prog = argv[0];
	ptr = strrchr(prog,'/');
	if (ptr)
		prog = ptr+1;

	for (c=1; c < argc; c++) {
		if (argv[c][0] >= '0' && argv[c][0] <= '9') {
			t.tv_sec = strtol(argv[c], NULL, 10);
			continue;
		}
		if (argv[c][0] != '-') {
			usage();
			return 1;
		}
		for (i=1; argv[c][i]; i++) {
			switch (argv[c][i]) {
			case 'h':
				action = HALT;
				break;
			case 'p':
				action = POWEROFF;
				break;
			case 'r':
				action = REBOOT;
				break;
			default:
				usage();
				return 1;
			}
		}
	}

	if (action==SHUTDOWN) {
		usage();
		return 1;
	}

	chdir("/");
	while (nanosleep(&t,&t)<0)
		if (errno!=EINTR) break;

	switch (action) {
	case HALT:
		do_halt();
		break;
	case POWEROFF:
		do_poweroff();
		break;
	case REBOOT:
		do_reboot();
		break;
	default: /* SHUTDOWN */
		break;
	}

	return 1;
}
