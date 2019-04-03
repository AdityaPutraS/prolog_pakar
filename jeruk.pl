/*  identifikasi jeruk


mulai dengan ?- mulai.     */
:- include('file_external.pl').
:- include('utility.pl').
:- dynamic ya/1,tidak/1.
:- dynamic hipotesis/1.


mulai :- hipotesis(Jeruk),
write('Saya pikir Jeruk itu adalah: '),
write(Jeruk),
nl,
ulang.

tambah :- 
    write('Masukan nama jeruk nya : '),
    read(NamaJeruk),
    write('Ada berapa ciri-ciri ? '),
    read(BanyakCiri),
    forall(between(1, BanyakCiri, I), (
        write('Masukkan ciri ciri ke -'), write(I), write(' : '),
        read(Ciri),
        write('Ciri jeruk '), write($NamaJeruk),write(' : '),write($Ciri)
    )),
    write('Data jeruk '),
    write($NamaJeruk),
    write(' berhasil dimasukkan.'), nl.

tambahJeruk([]) :- !.    
tambahJeruk([Jeruk1|Tail]) :-
    splitList(Jeruk1, '\n', JS),
    listLength(JS, LJS),
    ambil(JS, 1, NJ),
    listToStr(NJ, NamaJeruk),
    write(NamaJeruk), nl,
    LenJS is LJS-1,
    forall(between(2, LenJS, J), (
        NoSyarat is J-1,
        write('Syarat '), write(NoSyarat), write(' : '),
        ambil(JS, J, QueryJ),
        
        listToStr(QueryJ, SyaratJ),
        write(SyaratJ), nl
    )),
    nl,
    tambahJeruk(Tail).
updateData :-
    baca_file('d.txt', [_|S]),
    splitList(S, '-', Sp),
    tambahJeruk(Sp),
    write('Selesai update'), nl.

/* hipotesis yang akan dites */
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
hipotesis(tidak_dikenali).             /* tidak ada diagnosa */


/* aturan identifikasi cabai */
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

/* aturan klasifikasi */
manis :- periksa(memiliki_kandungan_gula_yang_tinggi).
manis_sedikit_asam :- periksa(memiliki_kandungan_manis_dan_asam_seimbang).
asam :- periksa(memiliki_kandungan_asam_sitrat_tinggi).


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


/* ulang semua penyataan ya/tidak */
ulang :- retract(ya(_)),fail.
ulang :- retract(tidak(_)),fail.
ulang.
