# Photolysis reaction numbers in different model frameworks

The tables below specify the links between reaction numbers used in the MCM/GECKO-A
protocol, in TUV 5.2.x for the following compound classes:

- [Inorganics](#inorganic-species)
- [n-Aldehydes](#linear-aldehydes)
- [Branched aldehydes](#branched-aldehydes)
- [Unsaturated aldehydes](#unsaturated-aldehydes)
- [Substituted aldehydes](#substituted-aldehydes)
- [Unbranched ketones](#unbranched-ketones)
- [Branched ketones](#branched-ketones)
- [Unsaturated ketones](#unsaturated-ketones)
- [Cyclic ketones](#cyclic-ketones)
- [Substituted ketones](#substituted-ketones)
- [Ketenes](#ketenes)
- [Dicarbonyls](#dicarbonyls)
- [Terminal n-alkyl nitrates](#terminal-linear-alkyl-nitrates)
- [Internal n-alkyl nitrates](#internal-linear-alkyl-nitrates)
- [Branched alkyl nitrates](#branched-alkyl-nitrates)
- [Substituted alkyl nitrates](#substituted-alkyl-nitrates)
- [Further nitrogen compounds](#further-nitrogen-compounds)
- [Alkyl dinitrates](#alkyl-dinitrates)
- [Alkyl hydroperoxides](#alkyl-hydroperoxides)
- [Criegee intermediates](#criegee-intermediates)
- [Polyfunctionals](#polyfunctional-chromophores)

Please ensure that `vers` is set to `2` in the `params` file in TUV.
This should set all cross section and quantum yield options correctly to
the preferred values in the MCM/GECKO-A protocol. You can double check that
options are check correctly for a given species by checking the 2. parameter
in xsvers or qyvers, respectively. The index compared to the log message
should yield in the option detailed in the MCM/GECKO-A protocol.

See also [schematics of the new protocol](Decision%20tree) or return to [start page](Home).


## Inorganic species

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
 J(1)       |    2 | O3 -> O2 + O(1D)
 J(2)       |    3 | O3 -> O2 + O(3P)
 J(3)       |    5 | H2O2 -> 2 OH
 J(4)       |    6 | NO2 -> NO + O(3P)
 J(5)       |    7 | NO3 -> NO + O2
 J(6)       |    8 | NO3 -> NO2 + O(3P)
 J(7)       |   12 | HNO2 -> OH + NO
 J(8)       |   13 | HNO3 -> OH + NO2
 J(9)       |   18 | HNO4 -> HO2 + NO2
 J(10)      |   19 | HNO4 -> OH + NO3

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Linear aldehydes

   MCM      | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(11011)  |   22 | CH2O -> H + HCO
  J(11012)  |   23 | CH2O -> H2 + CO
  J(11021)  |   24 | CH3CHO -> CH3 + HCO
  J(11022)  |   26 | CH3CHO -> CH3CO + H
  J(11031)  |   28 | C2H5CHO -> C2H5 + HCO
  J(11041)  |  134 | n-C3H7CHO -> n-C3H7 + CHO
  J(11042)  |  135 | n-C3H7CHO -> C2H4 + CH2CHOH
  J(11051)  |  141 | n-C4H9CHO -> C4H9 + CHO
  J(11061)  |  159 | n-C5H11CHO -> C5H11 + CHO
  J(11071)  |  167 | n-C6H13CHO -> C6H13 + CHO
  J(11081)  |  212 | n-C7H15CHO -> C7H15 + CHO

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Branched aldehydes

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(12011)  |  140 | i-C3H7CHO -> i-C3H7 + CHO
  J(12021)  |  149 | i-C4H9CHO -> C4H9 + CHO
  J(12022)  |  150 | i-C4H9CHO -> CH3CH=CH2 + CH2=CHOH
  J(12031)  |  152 | sec-C4H9CHO -> C4H9 + CHO
  J(12032)  |  153 | sec-C4H9CHO -> CH3CH=CHOH + CH2=CH2
  J(12041)  |  154 | t-C4H9CHO -> C4H9 + CHO
  J(12051)  |  183 | C4H9CH(C2H5)CHO -> C7H15 + CHO
  J(12061)  |  155 | tALD -> products
  J(12071)  |  156 | neoC5H11CHO -> neoC5H11 + CHO

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Unsaturated aldehydes

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(13011)  |   50 | CH2=CHCHO -> CH2=CH + CHO
  J(13012)  |   51 | CH2=CHCHO -> CH2=CH2 + CO
  J(13013)  |   53 | CH2=CHCHO -> CH2=CHCO + H
  J(13021)  |  177 | CH3CH=CHCHO -> CH3CH=CH + CHO
  J(13022)  |  178 | CH3CH=CHCHO -> CH3CH=CH2 + CO
  J(13023)  |  179 | CH3CH=CHCHO -> CH3CH=CHCO + H
  J(13031)  |  180 | 2-hexenal -> 1-pentenyl radical + CHO
  J(13032)  |  181 | 2-hexenal -> 1-pentene + CO
  J(13033)  |  182 | 2-hexenal -> C3H7CH=CHCO + H
  J(13041)  |  203 | hexadienal -> 1-pentenyl radical + CHO
  J(13042)  |  204 | hexadienal -> 1,3-pentadiene + CO
  J(13043)  |  205 | hexadienal -> CH3CH=CHCH=CHCO + H
  J(13051)  |   54 | CH2=C(CH3)CHO -> CH2=CCH3 + CHO
  J(13052)  |   55 | CH2=C(CH3)CHO -> CH3CH=CH2 + CO
  J(13053)  |   57 | CH2=C(CH3)CHO -> CH2=C(CH3)CO + H
  J(13061)  |  195 | CH3C(CH3)=CHCHO -> (CH3)2C=CH + CHO
  J(13062)  |  196 | CH3C(CH3)=CHCHO -> (CH3)2C=CH2 + CO
  J(13063)  |  197 | CH3C(CH3)=CHCHO -> (CH3)2C=CHCO + H
  J(13071)  |  187 | CH3CH=C(CH3)CHO -> CH3CH=CCH3 + CHO
  J(13072)  |  188 | CH3CH=C(CH3)CHO -> CH3CH=CHCH3 + CO
  J(13073)  |  189 | CH3CH=C(CH3)CHO -> CH3CH=C(CH3)CO + H
  J(13081)  |  220 | luALD -> NI products
  J(13082)  |  221 | luALD -> alkene + CO
  J(13083)  |  222 | luALD -> acyl + H

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Substituted aldehydes

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(15011)  |   62 | HOCH2CHO -> CH2OH + HCO
  J(15021)  |   29 | ALD3OH -> R(OH) + HCO
  J(15031)  |  136 | ALD4OH -> NI products
  J(15032)  |  137 | ALD4OH -> NII products
  J(15041)  |  144 | C5nALDOH -> NI products
  J(15051)  |  162 | C6nALDOH -> NI products
  J(15061)  |  170 | C7nALDOH -> NI products
  J(15071)  |  215 | C8nALDOH -> NI products
  J(15111)  |  185 | intAldOH -> R + CHO
  J(16021)  |  175 | Glycidaldehyde -> oxyranyl radical + CHO

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Unbranched ketones

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(21011)  |   65 | CH3COCH3 -> CH3CO + CH3
  J(21012)  |   66 | CH3COCH3 -> CO + 2 CH3
  J(21021)  |   67 | CH3COCH2CH3 -> CH3CO + CH2CH3
  J(21031)  |  230 | C3H7COCH3 -> CH3CO + C3H7
  J(21032)  |  232 | C3H7COCH3 -> C3H7 + CO + CH3
  J(21033)  |  233 | C3H7COCH3 -> CH3C(OH)=CH2 + CH2=CH2
  J(21041)  |  229 | C2H5COC2H5 -> C2H5CO + C2H5
  J(21051)  |  234 | C4H9COCH3 -> CH3CH=CH2 + CH2=C(OH)CH3
  J(21061)  |  235 | C3H7COC2H5 -> C2H5CO + C3H7
  J(21062)  |  236 | C3H7COC2H5 -> C3H7CO + C2H5
  J(21063)  |  237 | C3H7COC2H5 -> C3H7 + CO + C2H5
  J(21064)  |  238 | C3H7COC2H5 -> C2H5C(OH)=CH2 + CH2=CH2
  J(21071)  |  364 | lKET5 -> products
  J(21081)  |  239 | 4-heptanone -> NI products
  J(21091)  |  241 | 4-octanone -> NI products

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Branched ketones

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(22011)  |  244 | MIPK -> CH3CO + i-C3H7
  J(22012)  |  245 | MIPK -> i-C3H7CO + CH3
  J(22013)  |  246 | MIPK -> i-C3H7 + CO + CH3
  J(22014)  |  247 | MIPK -> CH2=CHOH + CH3CH=CH2
  J(22021)  |  248 | MIBK -> CH3CO + i-C4H9
  J(22031)  |  254 | 5-Me-2-hexanone -> CH3CO + CH2CH2CH(CH3)2
  J(22041)  |  252 | 4-Me-2-hexanone -> CH3C(OH)=CH2 + 2-butene
  J(22042)  |  253 | 4-Me-2-hexanone -> CH3C(OH)=CH2 + 1-butene
  J(22051)  |  258 | CH3CH(CH3)COCH(CH3)2 -> i-C3H7CO + i-C3H7
  J(22061)  |  264 | 2-Me-4-heptanone -> NI products
  J(22071)  |  267 | 3-Me-4-heptanone -> NI products
  J(22081)  |  269 | 2,2-Me-3-hexanone -> NI products
  J(22091)  |  271 | DIBK -> NI products
  J(22101)  |  273 | di-sec-butyl ketone -> NI products
  J(22111)  |  275 | di-t-butyl ketone -> NI products
  J(22121)  |  241 | 4-octanone -> NI products
  J(22131)  |  260 | n-C3H7COCH(CH3)2 -> NI products
  J(22141)  |  261 | n-C3H7COCH(CH3)2 -> i-C3H7COCH3 + C2H4
  J(22151)  |  262 | CH3COCH2C(CH3)3 -> NI products
  J(22161)  |  274 | di-sec-butyl ketone -> sec-C4H9COCH2CH3 + C2H4
  
 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Unsaturated ketones

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(23011)  |   59 | CH3COCH=CH2 -> CH3 + C2H3CO
  J(23021)  |  295 | CH3CH2COCH=CH2 -> C2H5 + C2H3CO

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Cyclic ketones

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(24011)  |  276 | c-C3H4O -> C2H4 + CO
  J(24012)  |  277 | c-C3H4O -> further products
  J(24021)  |  279 | c-C4H6O -> C2H4 + CH2=C=O
  J(24022)  |  281 | c-C4H6O -> c-C3H6 + CO
  J(24031)  |  283 | c-C5H8O -> 2 C2H4 + CO
  J(24032)  |  284 | c-C5H8O -> c-C4H8 + CO
  J(24033)  |  285 | c-C5H8O -> CH2=CHCH2CH2CHO
  J(24041)  |  287 | c-C6H10O -> 5-hexenal
  J(24042)  |  289 | c-C6H10O -> 1-pentene + CO
  J(24051)  |  291 | c-C7H12O -> 6-heptenal
  J(24052)  |  293 | c-C7H12O -> 1-hexene + CO

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Substituted ketones

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(25011)  |   68 | CH2(OH)COCH3 -> CH3CO + CH2(OH)
  J(25021)  |  299 | CH3COC2H4OH -> CH3 + COCH2CH2OH
  J(25031)  |  301 | CH3COCH(OH)CH3 -> CH3CO + CH3CHOH
  J(25041)  |  303 | CH3COC(CH3)2OH -> CH3 + (CH3)2C(OH)CO
  J(25071)  |   79 | CH3COCOOH -> CH3CHO + CO2
  J(25081)  |  304 | CH3COCH2C(CH3)2OH -> CH3COCH2 + CH3C(OH)CH3

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Ketenes

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(26011)  |  310 | CH2=C=O -> CO2 + CO + H2
  J(26012)  |  311 | CH3CH=C=O -> C2H4 + CO

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Dicarbonyls

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(31011)  |   70 | CHOCHO -> 2 HO2 + 2 CO
  J(31012)  |   72 | CHOCHO -> CH2O + CO
  J(31013)  |   73 | Ald (mult)
  J(31021)  |   75 | CH3COCHO -> CH3CO + HCO
  J(31031)  |   76 | CH3COCOCH3 -> Products
  J(33011)  |  313 | CHOCH=CHCHO -> 3H-furan-2-one
  J(33021)  |  315 | CH3COCH=CHCHO -> 5Me-3H-2-furanone
  J(33022)  |  316 | CH3COCH=CHCHO -> CH3 + CHOCH=CHCO
  J(33023)  |  317 | CH3COCH=CHCHO -> CH3COCH=CH2 + CO
  J(33031)  |  321 | CH3COCH=CHCOCH3 -> CH3CO + CH=CHCOCH3
  J(33041)  |  320 | CHOCH=CHCH=CHCHO -> diformyl cyclobutene
  J(34011)  |  322 | pinonaldehyde -> R + CO + HO2
  J(34021)  |  323 | caronaldehyde -> R + CO + HO2

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Terminal linear alkyl nitrates

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(41011)  |   34 | CH3ONO2 -> CH3O + NO2
  J(41021)  |   37 | C2H5ONO2 -> C2H5O + NO2
  J(41031)  |   38 | n-C3H7ONO2 -> C3H7O + NO2
  J(41041)  |   39 | 1-C4H9ONO2 -> 1-C4H9O + NO2
  J(41051)  |  324 | n-C5H11ONO2 -> n-C5H11O + NO2

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Internal linear alkyl nitrates

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(41111)  |   41 | CH3CHONO2CH3 -> CH3CHOCH3 + NO2
  J(41121)  |   40 | 2-C4H9ONO2 -> 2-C4H9O + NO2
  J(41131)  |  325 | 2-C5H11ONO2 -> 2-C5H11O + NO2
  J(41141)  |  326 | 3-C5H11ONO2 -> 3-C5H11O + NO2
  J(41151)  |  327 | C5H11ONO2 -> C5H11O + NO2

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Branched alkyl nitrates

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(42011)  |  329 | i-C4H9ONO2 -> i-C4H9O + NO2
  J(42021)  |   44 | C(CH3)3(ONO2) -> C(CH3)3(O.) + NO2
  J(42031)  |  330 | i-C5H11ONO2 -> i-C5H11O + NO2
  J(44011)  |  328 | c-C5H11ONO2 -> c-C5H11O + NO2

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Substituted alkyl nitrates

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(45011)  |   42 | CH2(OH)CH2(ONO2) -> CH2(OH)CH2(O.) + NO2
  J(45021)  |  331 | C1(OH)NO3 -> C1(OH)O + NO2
  J(45031)  |  332 | R(OH)NO3 -> R(OH)O + NO2
  J(45041)  |  333 | iR(OH)NO3 -> iR(OH)O + NO2
  J(45051)  |  334 | tR(OH)NO3 -> tR(OH)O + NO2

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Further nitrogen compounds

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(46011)  |  360 | CH3NO2 -> CH3 + NO2
  J(46012)  |  361 | RNO2 -> alkene + HONO
  J(46021)  |  362 | C2H5NO2 -> C2H5 + NO2
  J(46022)  |  363 | C2H5NO2 -> C2H4 + HONO
  J(47011)  |   35 | CH3(OONO2) -> CH3(OO) + NO2
  J(48011)  |   46 | CH3CO(OONO2) -> CH3CO(OO) + NO2
  J(48012)  |   47 | CH3CO(OONO2) -> CH3CO(O) + NO3
  J(48021)  |   48 | CH3CH2CO(OONO2) -> CH3CH2CO(OO) + NO2
  J(48022)  |   49 | CH3CH2CO(OONO2) -> CH3CH2CO(O) + NO3
  J(48031)  |  335 | PAN -> RCO(OO) + NO2
  J(48032)  |  336 | PAN -> RCO(O) + NO3

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Alkyl dinitrates

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(51011)  |  337 | CH3CH(NO3)CH2NO3 -> CH3CH(NO3)CH2O + NO2
  J(51021)  |  339 | C2H5CH(NO3)CH2NO3 -> C2H5CH(NO3)CH2O + NO2
  J(51031)  |  341 | CH3CH(NO3)CH(NO3)CH3 -> RO. + NO2
  J(53011)  |  342 | CH2(NO3)CH=CHCH2NO3 -> RO. + NO2
  J(53021)  |  343 | CH2=CHCH(NO3)CH2NO3 -> CH2=CHCH(NO3)CH2O + NO2

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Alkyl hydroperoxides

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(61011)  |   32 | CH3OOH -> CH3O + OH
  J(62011)  |  348 | (CH3)3COOH -> (CH3)3CO + OH
  J(65011)  |   33 | HOCH2OOH -> HOCH2O. + OH
  J(66011)  |   78 | CH3CO(OOH) -> Products

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Criegee intermediates

Below _j_ values are only recommendations and not part of the actual protocol
due to the insignificance of Criegee intermediate photolysis.

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(71011)  |  354 | CH2OO -> HCHO + O(3P)
  J(71021)  |  355 | CH3CHOO -> CH3CHO + O(3P)
  J(71022)  |  356 | synCH3CHOO -> CH3CHO + O(3P)
  J(71023)  |  357 | antiCH3CHOO -> CH3CHO + O(3P)
  J(71031)  |  358 | C2H5CHOO -> C2H5CHO + O(3P)
  J(72011)  |  359 | (CH3)2COO -> CH3COCH3 + O(3P)

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)


## Polyfunctional chromophores

MCM/GECKO-A | TUV  | TUV reaction label
-----------:|-----:|:------------------
  J(81011)  |   43 | CH3COCH2(ONO2) -> CH3COCH2(O.) + NO2
  J(81021)  |  349 | C2H5COCH2NO3 -> C2H5COCH2O + NO2
  J(81031)  |  350 | CH3COCH(NO3)CH3 -> CH3COCH(O.)CH3 + NO2
  J(81111)  |  352 | CH3COCH2CH2CH(OOH)CH3 -> RO. + OH
  J(81121)  |  353 | oxohexyl-hydroperoxide -> RO. + OH
  J(82011)  |   27 | genCH3CHO(poly)
  J(82021)  |   30 | genC2H5CHO(poly)
  J(82031)  |  138 | C4nALDpoly
  J(82041)  |  147 | C5nALDpoly
  J(82051)  |  165 | C6nALDpoly
  J(82061)  |  173 | C7nALDpoly
  J(82071)  |  218 | nALDpoly(C>7)
  J(82181)  |  226 | genluALD(poly)
  J(82121)  |  201 | genbMeuAld(poly)
  J(82131)  |  193 | genaMeuAld(poly)
  J(82211)  |  209 | genluuALD(poly)
  J(83011)  |   31 | genC2H5CHO(OHpoly)
  J(83021)  |  139 | C4nALDOHpoly
  J(83031)  |  148 | C5nALDOHpoly
  J(83041)  |  166 | C6nALDOHpoly
  J(83051)  |  174 | C7nALDOHpoly
  J(83061)  |  219 | nALDOHpoly(C>7)
  J(83111)  |  227 | genluALD(OHpoly)
  J(83121)  |  202 | genbMeuAldOH(poly)
  J(83131)  |  194 | genaMeuAldOH(poly)
  J(83211)  |  210 | genluuALD(OHpoly)
  J(84011)  |  278 | genC3cKet
  J(84021)  |  282 | genC4cKet
  J(84031)  |  286 | genC5cKet
  J(84041)  |  290 | genC6cKet
  J(84051)  |  294 | genC7cKet
  J(85011)  |  298 | genuKet(poly)
  J(86011)  |  312 | genKete(poly)
  J(88011)  |   74 | Ald (poly)
  J(88111)  |  314 | uDICARaa(poly)
  J(88121)  |  319 | uDICARak(poly)

 [Back to the top](#photolysis-reaction-numbers-in-different-model-frameworks)
