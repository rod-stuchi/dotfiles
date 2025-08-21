# GPG

## The PGP Agente config [timeout](https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session)
    ./gpg-agent.conf

is set to 38 hours (60 * 60 * 38) = 136800 seconds

## Clear password cache [link](https://askubuntu.com/questions/349238/how-can-i-clear-my-cached-gpg-password)

    gpg-connect-agent reloadagent /bye

## Output your public gpg key

    gpg --export --armor name@mail.com

## Keyservers

- keys.openpgp.org
- keyserver.ubuntu.com
- eys.gnupg.net
- pgp.mit.edu
- keybase.io
- keyoxide.org
