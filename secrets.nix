let
    server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+Qgbm5Xb4omuJFlfnxzBZTaPGnM3iUfVg2Xi02lX2c";
in
{
    "db-password.age".publicKeys = [ server ];
}
