# Scripts

These are some of the scripts I use in development, mostly written in Bash or Python.

- [Clear Caches](#clear-caches) - Clear user and system caches
- [Bash Header Generator](#bash-header-generator) - Create header information for new bash scripts

---

## upDoc

<p align="center">
  <strong>A CLI updates doctor</strong>
</p>

[**upDoc**](./updoc.sh) is a simple script to update a variety of my configs at the same time. It's still an early version that needs to be slimmed down and better adapted for scaling, but it works by running a series of updates, recording the results (pass/fail) for each process in a temporary file, and displaying final results. Eventually this will be run as a cron/launchd job to fully automate the process.

<img src="./updoc-1.png" alt="Screenshot of OMGWDYD script on CLI" />

<img src="./updoc-2.png" alt="Screenshot of OMGWDYD script on CLI" />

## Clear Caches

This is a simple script written in Bash to clear out user and system caches through the CLI. See the script [here](clear_caches.sh).

<img src="./clear_caches.png" alt="Screenshot of clear_cache script on CLI" />

## Bash Header Generator

This is a bash script for writing bash scripts. Upon execution it creates an interactive prompt to generate meta information for a bash script header. [Original source here](https://code.activestate.com/recipes/577862-bash-script-to-create-a-header-for-bash-scripts/). See the script [here](make_header.sh).

<img src="./make_headers-1.png" alt="Screenshot of make_headers script on CLI" />

<img src="./make_headers-2.png" alt="Screenshot of make_headers script on CLI" />
