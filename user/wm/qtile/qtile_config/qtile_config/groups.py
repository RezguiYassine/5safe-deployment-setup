from libqtile.config import Group

workspaces = Block((Group(str(i)) for i in range(1, 10)))
