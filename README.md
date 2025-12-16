### Project Title

Linux System Administration Menu (Bash Script)

### Project Type

Command-Line System Administration Utility

### Project Description

This project is a menu-driven Bash script that centralizes common Linux system administration tasks into a single terminal interface. The script allows an administrator to monitor system resources, manage backups, configure networking, control system services, administer users and groups, and inspect files within user home directories.

The application is structured using modular Bash functions and nested menus, making it easy to navigate and maintain. It demonstrates practical use of core Linux utilities, process management, file system operations, user and group administration, service control using systemd, and task scheduling with cron.

---

### Project Structure (Tree)

```
MainMenu.sh
│
├── System Status
│   ├── Memory usage monitoring
│   ├── CPU temperature check
│   ├── Active process listing
│   └── Process termination (PID)
│
├── Backup Management
│   ├── Scheduled backups (cron + tar)
│   └── Last backup reporting
│
├── Network Management
│   ├── Interface and IP display
│   ├── Interface enable/disable
│   ├── Manual IP assignment
│   └── Wi-Fi scanning and connection
│
├── Service Management
│   ├── List running services
│   └── Start/stop systemd services
│
├── User Management
│   ├── Create and delete users
│   ├── Grant sudo permissions
│   ├── View connected users
│   ├── Disconnect remote users
│   ├── View user groups
│   └── Modify group membership
│
└── File Management
    ├── Verify user and file existence
    ├── Display 10 largest files
    └── Display 10 oldest files
```

---

### Technologies Used

* Bash scripting
* Linux system utilities (`free`, `ps`, `ip`, `nmcli`, `systemctl`, `cron`)
* systemd
* sudo

---

### Target Environment

* Linux systems using systemd
* Terminal-based execution

---

### Intended Use

* Linux system administration practice
* Shell scripting coursework
* Lab and educational environments
* Portfolio demonstration

---

### Limitations

* Requires sudo privileges
* Not intended for production servers
* Assumes availability of systemd and NetworkManager
