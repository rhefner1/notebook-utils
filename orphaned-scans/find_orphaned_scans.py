import subprocess
import sys

NOTEBOOK_DIRECTORY = '/home/rhefner/Dropbox/notebook'


def main():
    for filename in sys.argv[1:]:
        if 'Scan' not in filename:
            continue

        filename = filename[filename.find('Scan'):]
        grep_cmd = "grep -R --exclude-dir='.git' '%s' %s" % (filename, NOTEBOOK_DIRECTORY)
        try:
            subprocess.check_output(grep_cmd, shell=True)
        except subprocess.CalledProcessError:
            print "%s could not be found." % filename


if __name__ == "__main__":
    main()
