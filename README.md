    
## CRIPTAREA
        Pentru partea de encriptare aleg registrul 'ebx' pentru a contoriza
    indexul literei din cuvant si registrul 'edx' ca si verificare pentru a
    sti daca a ajuns la finalul cuvantului. Retin in ecx numarul rundelor.
        Incep loop-ul prin a introduce in 'al' primul byte din textul pe
    care vreau sa-l criptez, la care voi adauga byte-ul corespunzator din
    cheie, urmand pasii prezentati in enunt. Fac apoi substitutia cu sbox,
    dupa care sunt nevoita sa cresc index-ul pentru a aduna urmatorul byte
    din text. Verific daca a terminat de parcurs tot cuvantul, caz in care
    'edx' devine 1. Indiferent de modificarea lui 'edx' fac actualizarea
    blocului : adun la 'al' urmatorul byte din bloc, il rotesc la stanga,
    dupa care actualizez byte-ul de pe pozitia urmatoare (adica actualul
    'ebx' care este deja modificat astfel incat sa fie modulo 8). La final
    mai fac o verificare pentru 'edx', iar daca nu e egal cu 1 (nu a ajuns
    la finalul cuvantului) reia loop-ul, altfel termina acest pas. 

## DECRIPTAREA
        Pentru partea de decriptare am urmat algoritmul invers encriptarii:
    incep de la ultima pozitie si initializez 'edx' cu 0, dupa care incep
    algoritmul propriu-zis : pastrez in 'al' byte-ul de pe pozitia 'ebx' 
    (indexul curent) pentru a-l aduna mai apoi cu cel corespondent cheii;
    aplic sbox si memorez in alt registru 'ah'  valoarea lui 'al'(top-ul).
    Iau o varibila auxiliara 'edx' pentru a calcula pozitia urmatoare modulo
    8 cu ajutorul functiei make_modulo_8, dupa care calculez diferenta.
    Rotesc la dreapta asa cum scrie in enunt, modific 'al' si devine
    bottom-ul, fac diferenta dintre top si bottom, pun rezultatul pe
    pozitia corespunzatoare , trec la pozitia urmatoare (cu o pozitie
    mai in spate) si verific daca am ajuns la finalul cuvantului. Daca
    n-am ajuns, reiau algoritmul, iar daca am ajuns trec la urmatorul pas.
    