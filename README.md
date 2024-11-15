## dhclient

L'objectif de ce projet est de re-créer la commande dhclient native sous Linux mais n'est pas présente par défaut sur macOS

- Le script est directement utilisable depuis n'importe quel répertoire
- Si vous souhaitez l'ajouter à votre système afin de bénéficier de l'autocomplétion vous pouvez déplacer le script dans le répertoire `/usr/local/bin` grâce à la commande `mv -v dhclient.sh /usr/local/bin` depuis le répertoire du script

Le script possède une fonction d'aide `help` montrant les paramètres et leurs possibles arguments que voici :

usage: dhclient [ -r `interface` | -d `interface` | -m `interface` | -w `on`/`off` ] [ -h ]
- -r pour libérer le bail DHCP/manuel en cours
- -m pour allouer manuellement l'adresse IP ainsi que le masque de sous-réseau
- -d pour allouer dynamiquement les paramètres réseaux via le protocole DHCP
- -h pour afficher le message d'aide
- -w pour activer ou désactiver le Wi-Fi
