CC := gcc
CFLAGS :=

SRC := src/main.c
OBJ := $(SRC:.c=.o)
TARGET := hello-c
BINDIR := $(out)/bin

.PHONY: all
all: $(TARGET)

$(TARGET): $(SRC)
	@echo "Compiling with: $(CC) $(CFLAGS) $(SRC) -o $(TARGET)"
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

.PHONY: install
install: $(TARGET)
	mkdir -p $(BINDIR)/
	cp $(TARGET) $(BINDIR)/

.PHONY: run
run: $(TARGET)
	@echo "Running $(TARGET) with arguments: $(ARGS)"
	$(BINDIR)/$(TARGET) $(ARGS)

.PHONY: clean
clean:
	rm -f $(OBJ) $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

