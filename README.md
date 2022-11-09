# OCDbgAnalysis
Tools to help with logs analysis

In an new Pharo9.0 64 bit image, do this:

```Smalltalk
Metacello new
    baseline: 'OCDbgAnalysis';
    repository: 'github://Pharo-XP-Tools/OCDbgAnalysis:main';
    load.
```
    
If you only want to load the packages from OCDbgAnalysis without the dependencies (If you have them installed already) do this:

```Smalltalk
"Fetches the packages, without loading them and without triggering the pre and post baseline hooks"

Metacello new
    baseline: 'OCDbgAnalysis';
    repository: 'github://Pharo-XP-Tools/OCDbgAnalysis:main';
    fetch.
    
"Manually load the package"
((IceRepository repositories detect: [ :r| r name = 'OCDbgAnalysis' ]) workingCopy packages detect: [:p| p package = 'OCDbgAnalysis' ]) load.
```Smalltalk
