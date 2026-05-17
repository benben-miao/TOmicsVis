# Network data from WGCNA tan module top-200 dataframe.

Network data from WGCNA tan module top-200 dataframe.

## Usage

``` r
data(network_data)
```

## Format

Dataframe: Network data from WGCNA tan module top-200 dataframe
(1st-col: Source, 2nd-col: Target).

## References

https://github.com/BioSciTools/BioSciToolsDatasets/tree/main/NetworkPlot/

## Author

benben-miao

## Examples

``` r
# 1. Library TOmicsVis package
library(TOmicsVis)

# 2. Load example data
data(network_data)

# 3. View example data
network_data
#>       Source   Target
#> 1      Cebpd    Cebpd
#> 2      CYR61    Cebpd
#> 3      Cebpd   CDKN1B
#> 4      CYR61   CDKN1B
#> 5       junb    Cebpd
#> 6     IGFBP1    Cebpd
#> 7     CDKN1B    Cebpd
#> 8      NR1D2    Cebpd
#> 9     CDKN1B     junb
#> 10     Cebpd    UBE2W
#> 11      egr1    Cebpd
#> 12   Zfp36l1    Cebpd
#> 13    CDKN1B    UBE2W
#> 14      egr1    Cebpd
#> 15     CYR61    Cebpd
#> 16      ier2    Cebpd
#> 17    IGFBP1   CDKN1B
#> 18   mfsd2ab    Cebpd
#> 19     Cebpd     ier2
#> 20   Zfp36l1   CDKN1B
#> 21      Brd2    Cebpd
#> 22   mfsd2ab   CDKN1B
#> 23  irf2bp2b    Cebpd
#> 24     pptc7    Cebpd
#> 25     NR1D2   CDKN1B
#> 26   Zfp36l1    Cebpd
#> 27      ier2   CDKN1B
#> 28     CYR61     JUND
#> 29  irf2bp2b   CDKN1B
#> 30     Cebpd    CEBPA
#> 31     Cebpd    UBE2W
#> 32     CEBPA    Cebpd
#> 33     Cebpd     junb
#> 34    CDKN1B     spp2
#> 35      egr1   CDKN1B
#> 36    IGFBP1    CEBPA
#> 37      Brd2   CDKN1B
#> 38      egr1   CDKN1B
#> 39     Cebpd     junb
#> 40     pptc7   CDKN1B
#> 41   ZFP36L1    Cebpd
#> 42    IGFBP1    Cebpd
#> 43     Cebpd     spp2
#> 44     CYR61 irf2bp2b
#> 45     NR1D2    Cebpd
#> 46    IGFBP1     JUND
#> 47     Cebpd     ier2
#> 48    CDKN1B     junb
#> 49     Cebpd     egr1
#> 50   Zfp36l1      PLG
#> 51     CYR61  Zfp36l1
#> 52      JUND     junb
#> 53   Zfp36l1    Cebpd
#> 54     Cebpd    PLIN2
#> 55    CDKN1B     ier2
#> 56      JUND    CEBPA
#> 57   mfsd2ab    Cebpd
#> 58     pptc7    Cebpd
#> 59    CDKN1B     egr1
#> 60     Cebpd  ZFP36L1
#> 61   Zfp36l1   CDKN1B
#> 62    CDKN1B  ZFP36L1
#> 63      ier2    Cebpd
#> 64     Cebpd     spp2
#> 65      JUND    Cebpd
#> 66     CYR61   IGFBP1
#> 67    CDKN1B    CEBPA
#> 68   Zfp36l1 irf2bp2b
#> 69    IGFBP1 irf2bp2b
#> 70     CYR61    CEBPA
#> 71     CYR61      PLG
#> 72      junb     junb
#> 73      Brd2  ZFP36L1
#> 74     CYR61  ZFP36L1
#> 75     CYR61    pptc7
#> 76     CYR61     Brd2
#> 77      JUND    Cebpd
#> 78      Brd2    Cebpd
#> 79      egr1    Cebpd
#> 80   Zfp36l1     Brd2
#> 81   Zfp36l1   IGFBP1
#> 82     Cebpd     egr1
#> 83     NR1D2   CDKN1B
#> 84  irf2bp2b  ZFP36L1
#> 85     pptc7  ZFP36L1
#> 86      CTGF    Cebpd
#> 87     NR1D2    ITIH2
#> 88   Zfp36l1  Zfp36l1
#> 89    CDKN1B    PLIN2
#> 90     NR1D2    Cebpd
#> 91      egr1    Cebpd
#> 92  irf2bp2b    Cebpd
#> 93   mfsd2ab    UBE2W
#> 94     Cebpd     Noct
#> 95     Cebpd     AHSG
#> 96   Zfp36l1    Cebpd
#> 97    CDKN1B     SAT1
#> 98    IGFBP1     junb
#> 99  irf2bp2b    UBE2W
#> 100     SAT1    Cebpd
#> 101     Noct    Cebpd
#> 102  mfsd2ab     junb
#> 103     JUND   CDKN1B
#> 104    CYR61  mfsd2ab
#> 105 irf2bp2b     junb
#> 106 irf2bp2b     ier2
#> 107   IGFBP1  mfsd2ab
#> 108    Cebpd     AHSG
#> 109  mfsd2ab    CEBPA
#> 110     CTGF   CDKN1B
#> 111      PLG    NR1D2
#> 112    pptc7    CEBPA
#> 113    Cebpd     junb
#> 114     JUND     junb
#> 115    SRSF2    Cebpd
#> 116 irf2bp2b  Zfp36l1
#> 117   CDKN1B     AHSG
#> 118    CYR61  Zfp36l1
#> 119    NR1D2    ABHD5
#> 120    CYR61  Ppp1r3g
#> 121  Zfp36l1    Cebpd
#> 122   IGFBP1  Zfp36l1
#> 123     JUND  mfsd2ab
#> 124    Cebpd     ier2
#> 125      PLG  Zfp36l1
#> 126 irf2bp2b  mfsd2ab
#> 127   CDKN1B    CYB5A
#> 128    NR1D2     egr1
#> 129     junb    CEBPA
#> 130     NMT3    Cebpd
#> 131    CYB5A    Cebpd
#> 132    pptc7  Zfp36l1
#> 133  Zfp36l1    pptc7
#> 134     Brd2    PLIN2
#> 135  Zfp36l1    NR1D2
#> 136     CTGF  mfsd2ab
#> 137  Zfp36l1     JUND
#> 138     Brd2  Zfp36l1
#> 139    Cebpd    CYB5A
#> 140     JUND      PLG
#> 141 irf2bp2b     ier2
#> 142     egr1    ABHD5
#> 143     NMT3   CDKN1B
#> 144   IGFBP1  ZFP36L1
#> 145    NR1D2    Cebpd
#> 146    CYR61  Zfp36l1
#> 147    Cebpd     AHSG
#> 148  Zfp36l1    ITIH2
#> 149   CDKN1B     AHSG
#> 150 irf2bp2b     SAT1
#> 151  mfsd2ab     ier2
#> 152     CTGF    Cebpd
#> 153     egr1 irf2bp2b
#> 154  Zfp36l1    Cebpd
#> 155    CYR61     AHSG
#> 156   Pgrmc1     Brd2
#> 157     egr1    ABHD5
#> 158    SRSF2   CDKN1B
#> 159     Brd2    CYB5A
#> 160    Cebpd     ier2
#> 161      PLG    Cebpd
#> 162  Zfp36l1      PLG
#> 163     egr1    ITIH2
#> 164      PLG    CEBPA
#> 165     Brd2    NR1D2
#> 166 irf2bp2b    CEBPA
#> 167     Brd2   Errfi1
#> 168 irf2bp2b     Brd2
#> 169    Cebpd    PLIN2
#> 170      PLG    Cebpd
#> 171  Zfp36l1     spp2
#> 172    CYR61     junb
#> 173   IGFBP1    pptc7
#> 174   CDKN1B     Noct
#> 175     ARG1   Errfi1
#> 176     JUND irf2bp2b
#> 177    NR1D2    ABHD5
#> 178    CYR61     junb
#> 179 irf2bp2b     junb
#> 180  Zfp36l1  mfsd2ab
#> 181    pptc7     Brd2
#> 182     ier2     junb
#> 183     egr1     Brd2
#> 184    SRSF2    Cebpd
#> 185  mfsd2ab     junb
#> 186     junb     ier2
#> 187     Brd2  Ppp1r3g
#> 188  mfsd2ab     ier2
#> 189    Cebpd     AHSG
#> 190      PLG    CYR61
#> 191     egr1 irf2bp2b
#> 192     egr1    NR1D2
#> 193    pptc7     spp2
#> 194     egr1      PLG
#> 195    Cebpd     SAT1
#> 196     Brd2     AHSG
#> 197     ier2     ier2
#> 198   Pgrmc1   Errfi1
#> 199 irf2bp2b    pptc7
#> 200   IGFBP1     junb
```
