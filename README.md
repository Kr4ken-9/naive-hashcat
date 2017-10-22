# Naive Hashcat

Crack password hashes without the fuss. Naive hashcat is a plug-and-play script that is pre-configured with naive, emperically-tested, "good enough" parameters/attack types. Run hashcat attacks using `./naive-hashcat.sh` without having to know what is going on under the hood.

__DISCLAIMER: This software is for educational purposes only. This software should not be used for illegal activity. The author is not responsible for its use. Don't be a dick.__

## Getting started

```bash
git clone --recursive git@github.com:Kr4ken-9/naive-hashcat.git
cd naive-hashcat

# Build hashcat
# from https://github.com/hashcat/hashcat/blob/master/BUILD.md
./build.sh


# download the 134MB rockyou dictionary file
curl -L -o dicts/rockyou.txt https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt

# cracks md5 hashes in hashcat-3.6.0/example0.hash by default
./naive-hashcat.sh
```

## What does it do?

`./naive-hashcat.sh` assumes that you have hashed passwords that you would like to know the plaintext equivalent of. Likely, you've come across a text file that contains leaked accounts/emails/usernames matched with a cryptographic hash of a corresponding password. Esentially something that looks like:

```
neli_dayanti@yahoo.co.id:01e870ebb01160f881ffaa6764acd01f
hastomoanggi@gmail.com:f15a413c1835014679a286ee84a212d4
yogipandu86@gmail.com:e4fdf3291654751def4e6816fddce608
fadlilamegy1@gmail.com:8ebd79c9b13240ab3767a64b4faae7be
ridho6kr@gmail.com:33816712db4f3913ee967469fe7ee982
yogaardamanta17@gmail.com:3e46fb7125915cdf34df21342004f82f
yogahadikusuma@gmail.com:bf0e20a03a01ae215deb9b36e173cd9a
```

(⬆⬆⬆ not real hashes btw, don't get any ideas...)

If you don't have such a file, [pastebin.com](http://pastebin.com) is a popular text paste site that black-hat hackers 💙 love 💙 posting leaked account credentials to. And lucky 4 u, they have a [trending feature](https://pastebin.com/trends) that makes "interesting content" bubble to the top. If you can't find leaked creds atm, I've written a [tool that archives trending pastes](https://github.com/brannondorsey/pastebin-mirror) each hour.

Once you've got some hashes, save them to a file with one hash per line. For example, `hashes.txt`:

```
01e870ebb01160f881ffaa6764acd01f
f15a413c1835014679a286ee84a212d4
e4fdf3291654751def4e6816fddce608
8ebd79c9b13240ab3767a64b4faae7be
33816712db4f3913ee967469fe7ee982
3e46fb7125915cdf34df21342004f82f
bf0e20a03a01ae215deb9b36e173cd9a
```

To crack your hashes, pass this file as `HASH_FILE=hashes.txt` to the command below.

## Usage

`naive-hashcat.sh` takes, at most, three parameters. All parameters are expressed using unix environment variables. The command below shows the default values set for each of the configurable environment variables that `naive-hashcat.sh` uses:

```bash
HASH_FILE=hashcat/examples0.hash POT_FILE=hashcat.pot HASH_MODE=0 ./naive-hashcat.sh
```

- `HASH_FILE` is a text file with one hash per line. These are the password hashes to be cracked.
- `POT_FILE` is the name of the output file that `hashcat` will write cracked password hashes to.
- `HASH_TYPE` is the hash-type code. It describes the type of hash to be cracked. `0` is [md5](https://en.wikipedia.org/wiki/MD5). See the [Hash types](#hash-types) section below for a full list of hash type codes.

## What naive-hashcat does

[`naive-hashcat.sh`](naive-hashcat.sh) includes a small variety of [dictionary](https://hashcat.net/wiki/doku.php?id=dictionary_attack), [combination](https://hashcat.net/wiki/doku.php?id=combinator_attack), [rule-based](https://hashcat.net/wiki/doku.php?id=rule_based_attack), and [mask](https://hashcat.net/wiki/doku.php?id=mask_attack) (brute-force) attacks. If that sounds overwhelming, don't worry about it! The point of naive hashcat is that you don't have to know how it works. In this case, ignorance is bliss! In fact, I barely know what I'm doing here. The attacks I chose for `naive-hashcat.sh` are very naive, one-size-kinda-fits-all solutions. If you are having trouble cracking your hashes, I suggest checking out the __awesome__ [hashcat wiki](https://hashcat.net/wiki/), and using the `hashcat` tool directly.

At the time of this writing, `naive-hashcat` cracks ~60% of the hashes in `examples0.hash`.

## Ok, I think its working... what do I do now?

So you've run `./naive-hashcat.sh` on your `HASH_FILE`, and you see some passwords printing to the screen. These `hash:password` pairs are saved to the `POT_FILE` (`hashcat.pot` by default). Now you need to match the hashes from the original file you... um... found (the with lines like `neli_dayanti@yahoo.co.id:01e870ebb01160f881ffaa6764acd01f`) to the `hash:password` pairs in your pot file.

Run `python match-creds.py --accounts original_file.txt --potfile hashcat.pot > creds.txt` to do just that! This tool matches usernames/emails in `original_file.txt` with their corresponding cracked passwords in `hashcat.pot` and prints `username:password`:

```
neli_dayanti@yahoo.co.id:Password1
hastomoanggi@gmail.com:Qwerty1234
yogipandu86@gmail.com:PleaseForHeavenSakeUseAPasswordManager
```

Congratulations, you just hacked the private passwords/account information of many poor souls. And because everyone still uses the same password for everything you likely have the "master" password to tons of accounts.

And remember
  1. use a [password manager](https://www.lastpass.com/)
  2. don't pwn people
  3. don't go to jail

🏴‍ Happy hacking ☠

P.S. `./naive-hashcat.sh` can take anywhere from a few minutes to a few hours to terminate depending on your hardware. It will constantly stream results to the `POT_FILE`, and you are free to use the contents of that file for further processing with `match-creds.py` before cracking is finished.

## GPU Cracking

Hashcat ships with OpenCL and runs on available GPU hardware automatically when available.

## Hash types

Supported hash types can be found here: https://hashcat.net/wiki/doku.php?id=example_hashes

If you don't know the type of hash you have, you can use [`hashid`](https://github.com/psypanda/hashID) to try and identify it. Include the appropriate hash-type using the `HASH_TYPE` environment variable.