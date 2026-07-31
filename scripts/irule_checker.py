import os, sys, re, yaml

TERMINAL_HTTP_CMDS = [r"HTTP::respond", r"HTTP::redirect", r"HTTP::retry"]

def check_syntax(file_path):
    """Basic brace and bracket matching check."""
    with open(file_path, "r") as f:
        content = f.read()
    
    # Check matching braces
    if content.count("{") != content.count("}"):
        print(f"FAILED Syntax Error in {file_path}: Mismatched curly braces {{ }}")
        return False
    if content.count("[") != content.count("]"):
        print(f"FAILED Syntax Error in {file_path}: Mismatched square brackets [ ]")
        return False
    return True

def check_vs_conflicts(vs_name, irule_files):
    """Checks for conflicting logic across multiple iRules on the same VS."""
    event_actions = {}
    has_errors = False

    for file_name in irule_files:
        path = os.path.join("irules", file_name)
        if not os.path.exists(path):
            print(f"FAILED File not found: {path}")
            return False

        with open(path, "r") as f:
            content = f.read()

        # Parse event blocks (e.g., when HTTP_REQUEST { ... })
        events = re.findall(r"when\s+([A-Z_]+)\s*\{([^}]+)\}", content)
        for event_name, event_body in events:
            if event_name not in event_actions:
                event_actions[event_name] = []

            for cmd in TERMINAL_HTTP_CMDS:
                if re.search(cmd, event_body):
                    event_actions[event_name].append((file_name, cmd))

    # Evaluate logic conflicts
    for event, actions in event_actions.items():
        if len(actions) > 1:
            print(f"WARNING Logic Conflict on VS '{vs_name}' in event '{event}':")
            for rule, cmd in actions:
                print(f"   - iRule '{rule}' issues '{cmd}'")
            print("   Multiple terminal HTTP commands in the same event will cause BIG-IP TCL runtime errors unless handled with event disable or HTTP::has_responded.\n")
            has_errors = True

    return not has_errors

def main():
    with open("config/virtual-servers.yaml") as f:
        config = yaml.safe_load(f)

    overall_pass = True

    # 1. Syntax Check on all iRules
    print("=== Step 1: Checking iRule Syntax ===")
    for rule in os.listdir("irules"):
        if rule.endswith(".tcl"):
            if not check_syntax(os.path.join("irules", rule)):
                overall_pass = False

    # 2. Conflict Check per Virtual Server
    print("\n=== Step 2: Checking Multi-iRule Conflicts ===")
    for vs in config.get("virtual_servers", []):
        vs_name = vs["name"]
        attached_irules = vs["irules"]
        print(f"Checking Virtual Server: {vs_name} ({len(attached_irules)} iRules attached)")
        if not check_vs_conflicts(vs_name, attached_irules):
            overall_pass = False

    if not overall_pass:
        sys.exit(1)
    print("All static checks passed successfully!")

if __name__ == "__main__":
    main()