/*  identifikasi jeruk


mulai dengan ?- mulai.     */
:- include('file_external.pl').
:- include('utility.pl').
:- dynamic ya/1,tidak/1.
:- dynamic hipotesis/1.
:- dynamic periksa/1.


mulai :- hipotesis(Jeruk),
write('Saya pikir Jeruk itu adalah: '),
write(Jeruk),
nl,
ulang.

normSyarat([], []) :- !.
normSyarat([' '|T], ['_'|H]) :-
    normSyarat(T, H), !.
normSyarat([X|T], [XLower|H]) :-
    string_lower(X, XLower),
    normSyarat(T, H), !.
    
concatSyarat([L], A, Hasil) :-
    normSyarat(L, Last),
    concatList(['periksa('], Last, Temp1),
    concatList(Temp1, [')'], Temp2),
    concatList(A, Temp2, H1),
    concatList(H1, [')'], Hasil), !.
    
concatSyarat([S|T], A, Hasil) :-
    normSyarat(S, Syarat),
    concatList(['periksa('], Syarat, Temp1),
    concatList(Temp1, [')'], Temp2),
    concatList(A, Temp2, H1),
    concatList(H1, [', '], H2),
    concatSyarat(T, H2, Hasil), !.
 
tambahJeruk([]) :- !.     
tambahJeruk([Jeruk1|Tail]) :-
    splitList(Jeruk1, '\n', [_, NJ|Syarat]),
    normSyarat(NJ, NJNorm),
    concatList(NJNorm, [' :- '], Awal),
    concatSyarat(Syarat, [''], Hasil),
    concatList(Awal, Hasil, StrFakta),
    concatList(['('], StrFakta, Fakta),
    listToStr(Fakta, StringFakta),
    /*write('String Fakta : '), write(StringFakta), nl,*/
    atom_to_term(StringFakta, Term, _),
    assert(Term),
    listToStr(NJNorm, NamaJeruk),
    concatList(['(hipotesis('], NJNorm, Hipot),
    concatList(Hipot, [') :- '], Hipot2),
    concatList(Hipot2, NJNorm, Hipot3),
    concatList(Hipot3, [', !)'], Hipot4),
    listToStr(Hipot4, StringHipot),
    /*write('String Hipot : '), write(StringHipot), nl,*/
    atom_to_term(StringHipot, TermHipot, _),
    assert(TermHipot),
    write(NamaJeruk), write(' berhasil ditambahkan'), nl,
    tambahJeruk(Tail).

resetData :-
    write('Hapus semua hipotesis'),nl,
    retract(hipotesis(_)), fail.
resetData :-
    write('Hapus semua periksa'),nl,
    retract(periksa(_)), fail.
resetData :-
    write('Hapus semua ya/tidak'),nl,
    ulang, fail.
resetData.

updateData :-
    resetData,
    baca_file('d.txt', [_|S]),
    splitList(S, '-', Sp),
    tambahJeruk(Sp),
    assert((hipotesis(tidak_dikenal) :- !)),
    write('Selesai update'), nl.

/* hipotesis yang akan dites
hipotesis(jeruk_nipis)   :- nipis, !.
hipotesis(jeruk_sukade)     :- sukade, !.
hipotesis(jeruk_bali)   :- jeruk_bali, !.
hipotesis(jeruk_keprok)  :- keprok, !.
hipotesis(jeruk_purut)   :- purut, !.
hipotesis(jeruk_lemon)   :- lemon, !.
hipotesis(jeruk_navel) :- navel, !.
hipotesis(jeruk_satsuma):- satsuma, !.
hipotesis(jeruk_siam):- siam, !.
hipotesis(jeruk_mandarin):- mandarin, !.
hipotesis(jeruk_mikam):- mikam, !.
hipotesis(jeruk_nagami):- nagami, !.
hipotesis(jeruk_jari_budha):- jari_budha, !.   
hipotesis(tidak_dikenali). 
*/

/* aturan identifikasi jeruk
nipis :- asam,
periksa(kulit_tebal_dan_sulit_dibuka),
periksa(berwarna_hijau_dan_kekuningan),
periksa(daging_tebal_dan_tidak_ada_serabut).


sukade :- asam,
periksa(kulit_tebal),
periksa(bagian_dalam_dan_bulir_kecil),
periksa(buahnya_jarang_dikonsumsi),
periksa(kulitnya_dipakai_masakan_dan_selai).


jeruk_bali :- manis_sedikit_asam,
periksa(ukuran_buah_besar),
periksa(kulit_tebal),
periksa(memiliki_sedikit_biji),
periksa(dalam_buah_berwarna_putih_sampai_kemerahan).


keprok :- manis_sedikit_asam,
periksa(kulit_tipis),
periksa(ukuran_kecil),
periksa(banyak_biji_dan_daging_tebal).
-----------------------------------------------
purut :- asam,
periksa(kulit_buah_keriput_dan_tak_beraturan),
periksa(daging_buah_tipis_dan_banyak_biji),
periksa(digunakan_untuk_bumbu_masakan).


lemon :- asam,
periksa(berbentuk_oval),
periksa(kulit_berwarna_kuning_muda),
periksa(daging_buah_sedikit).

navel :- manis,
periksa(berwarna_kuning_orange),
periksa(bentuk_oval),
periksa(bulir_kecil_dan_daging_agak_tebal).


satsuma :- manis_sedikit_asam,
periksa(bentuk_mirip_buah_pear),
periksa(memiliki_banyak_kadar_air),
periksa(tidak_mempunyai_biji).


siam :- manis,
periksa(kulit_tebal_dan_kuat),
periksa(bagian_dalam_berkerut_dan_berserabut),
periksa(warna_hijau_kekuningan_dan_tekstur_pori-pori_kuning).

mandarin :- manis,
periksa(ukuran_kecil),
periksa(berwarna_orange),
periksa(berasal_dari_china),
periksa(tidak_mempunyai_biji).

mikam :- manis,
periksa(berasal_dari_jepang),
periksa(bagian_dalam_berpori_dan_tidak_berserabut),
periksa(memiliki_biji),
periksa(berwarna_hijau).

nagami :- manis,
periksa(bentuk_buah_lonjong),
periksa(ukuran_buah_kecil),
periksa(kulitnya_bisa_dimakan).

jari_budha :- asam,
periksa(berbentuk_seperti_jari),
periksa(berwarna_kuning),
periksa(digunakan_untuk_pengharum_ruangan_dan_masakan).


manis :- periksa(memiliki_kandungan_gula_yang_tinggi).
manis_sedikit_asam :- periksa(memiliki_kandungan_manis_dan_asam_seimbang).
asam :- periksa(memiliki_kandungan_asam_sitrat_tinggi).
*/

/* Bagaimana cara bertanya */
tanya(Pertanyaan) :-
write('Apakah jeruk itu mempunyai ciri '),
write(Pertanyaan),
write('?'),
read(Jawaban),
nl,
( (Jawaban== ya ; Jawaban == y)
->
assert(ya(Pertanyaan)) ;
assert(tidak(Pertanyaan)), fail).



/* Bagaimana memeriksa sesuatu */
periksa(S) :-
(ya(S)
->
true ;
(tidak(S)
->
fail ;
tanya(S))).


/* ulang semua penyataan yatidak */
ulang :- retract(ya(_)),fail.
ulang :- retract(tidak(_)),fail.
ulang.
