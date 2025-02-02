# Motoko migrations

Sample project structure to implement migrations in motoko

## Migration example

### Install 0_1_0

```bash
dfx create canister motoko_migrations
dfx build
fx canister install motoko_migrations --argument='(variant { init = record { controller = principal "aaaaa-aa" } } )'
```

### Upgrade to 0_2_0

In main.mo, change every occurence of v0_1_0 to v0_2_0. In src/migrations/types.mo, change to Current = Migrations002. Then upgrade the canister with:

```bash
dfx canister install motoko_migrations --argument='(variant { upgrade = record { controllers = vec {} } } )' --mode=upgrade
```

### Upgrade to 0_3_0

In main.mo, change every occurence of v0_2_0 to v0_3_0. In src/migrations/types.mo, change to Current = Migrations003. In WrappedState.mo, comment the first class and uncomment the second class. Then upgrade the canister with:

```bash
dfx canister install motoko_migrations --argument='(variant { upgrade = record { controllers = vec {} ; schoolName="polytechnique"; } } )' --mode=upgrade
```

### Downgrade to 0_2_0

Still use v3 to downgrade state
```bash
dfx canister install motoko_migrations --argument='(variant { downgrade = record {} } )' --mode=upgrade --upgrade-unchanged
```
Then use v2 to update canister interface
```bash
dfx canister install motoko_migrations --argument='(variant { none } )'
```
### Downgrade to 0_1_0

Still use v2 to downgrade state
```bash
dfx canister install motoko_migrations --argument='(variant { downgrade = record { controller = "aaaaa-aa" } } )' --mode=upgrade --upgrade-unchanged
```
Then use v1 to update canister interface
```bash
dfx canister install motoko_migrations --argument='(variant { none } )' --mode=upgrade
```

## Misc

To add a teacher (v0_1_0):
```bash
dfx canister call motoko_migrations addTeacher '(record {firstName="john"; lastName="petrucci"; subject="guitar"})'
```

To add a student (v0_1_0):
```bash
dfx canister call motoko_migrations addStudent '(record {firstName="jack"; lastName="black"; speciality="singer"})'
```

To fetch teachers:
```bash
dfx canister call motoko_migrations fetchTeachers
```

To fetch students:
```bash
dfx canister call motoko_migrations fetchStudents
```