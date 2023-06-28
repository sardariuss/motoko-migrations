# Motoko migrations

Sample project structure to implement migrations in motoko

## Migration example

### Install 0_1_0

```bash
dfx create canister motoko_migrations
dfx build
dfx canister install motoko_migrations --argument='(variant { init = variant { v0_1_0 = record { controller = principal "aaaaa-aa" } } } )'
```

### Upgrade to 0_2_0

In main.mo, change every occurence of v0_1_0 to v0_2_0. In src/migrations/types.mo, change to Current = Migrations002. Then upgrade the canister with:

```bash
dfx canister install motoko_migrations --argument='(variant { upgrade = vec { variant { v0_2_0 = record { controllers = vec {principal "tsfj2-4p75k-3nxgx-2zlqp-jvi"; principal "qs2ge-3kbft-lnn6j-e5hxb-gxi" } } } } } )' --mode=upgrade
```

### Upgrade to 0_3_0

In main.mo, change every occurence of v0_2_0 to v0_3_0. In src/migrations/types.mo, change to Current = Migrations003. In WrappedState.mo, comment the first class and uncomment the second class. Then upgrade the canister with:

```bash
dfx canister install motoko_migrations --argument='(variant { upgrade = vec { variant { v0_3_0 = record { schoolName="school of rock"; } } } } )' 
--mode=upgrade
```

### Downgrade to 0_2_0

In main.mo, change every occurence of v0_3_0 to v0_2_0. In src/migrations/types.mo, change to Current = Migrations002. In WrappedState.mo, comment the second class and comment the first class. Then upgrade the canister with:

```bash
dfx canister install motoko_migrations --argument='(variant { downgrade = vec {} } )' --mode=upgrade
```

### Downgrade to 0_1_0

In main.mo, change every occurence of v0_3_0 to v0_2_0. In src/migrations/types.mo, change to Current = Migrations002. Then upgrade the canister with:

```bash
dfx canister install motoko_migrations --argument='(variant { downgrade = vec { variant { v0_1_0 = record { controller = principal "aaaaa-aa" } } } } )' --mode=upgrade
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