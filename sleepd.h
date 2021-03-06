#define PKG_NAME "sleepd"
#define PKG_MAIL "matzeton@googlemail.com"
#define PKG_VERSION_MAJOR 2
#define PKG_VERSION_MINOR 12

#define MAX_IRQS 255
#define MAX_NET 8
#define INTERRUPTS "/proc/interrupts"
#define DEFAULT_SLEEP_TIME 10
#define PID_FILE "/var/run/sleepd.pid"
#define TXFILE "/sys/class/net/%s/statistics/tx_packets"
#define TXRATE 15
#define RXFILE "/sys/class/net/%s/statistics/rx_packets"
#define RXRATE 25
#define SHM_NAME "/sleepd-shm"
#define IPC_MAXTRIES 10
#define MINIMAL_UNUSED 10
#define MAX_SAMPLES 100
#define MAX_UNUSED 10*60
