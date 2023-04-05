1. Stitch all individual channels.
2. Create binary soma, neurites, and mito maps.
3. Create distance-transformed neurites binary. 
(3. Chop stitched into tiles.) Not strictly necessary, if stitched image not too large.
4. Run ImageJ mitography analysis.
5. Run MATLAB turnoveranalysis.

turnoveranalysis.txt data columns:
1-8	Same as MitoAnalysis.txt (ImageJ)
9	somabinary (1=True/0=False)
10	Distance to soma (µm)
11	Signal in label1 channel
12	Signal in label2 channel
13	Mitochondria circularity