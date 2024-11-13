# dhclient

L'objectif de ce projet est de re-créer la commande dhclient native sous Linux mais n'est pas présente par défaut sur macOS

- Le script est directement utilisable depuis n'importe quel répertoire
- Si vous souhaitez l'ajouter à votre système afin de bénéficier de l'autocomplétion vous pouvez déplacer le script dans le répertoire `/usr/local/bin` grâce à la commande `mv -v dhclient.sh /usr/local/bin` depuis le répertoire du script

Le script possède une fonction d'aide `help` montrant les paramètres et leurs possibles arguments que voici :

usage: dhclient [ -r <interface> | -d <interface> | -m <interface> ] [ -h ]
        -r stand for releasing your actual lease
        -m stand for setting manually your IP address and Subnet Mask
        -d stand for setting dynamicly your IP address and Subnet Mask via DHCP Algorithm
        -h stand for printing this actual help message
