import random

def mulai_permainan():
    print("=== SIMULASI SURVIVE THE KILLER (FANN Project) ===")
    
    # Status awal
    jarak_killer = 20  # meter
    pintu_terbuka = False
    putaran = 1

    while jarak_killer > 0:
        print(f"\nPutaran {putaran}")
        print(f"Jarak Killer: {jarak_killer} meter")
        
        aksi = input("Aksi kamu (lari/sembunyi): ").lower()
        
        if aksi == "lari":
            # Lari menjauh tapi killer juga mengejar
            gerak_kamu = random.randint(3, 7)
            gerak_killer = random.randint(2, 6)
            jarak_killer = jarak_killer + gerak_kamu - gerak_killer
            print(f"Kamu lari sejauh {gerak_kamu}m, tapi Killer mendekat {gerak_killer}m!")
        
        elif aksi == "sembunyi":
            # Kesempatan Killer tidak bergerak
            if random.random() > 0.5:
                print("Berhasil! Killer kehilangan jejakmu sejenak.")
            else:
                gerak_killer = random.randint(1, 4)
                jarak_killer -= gerak_killer
                print(f"Killer masih mencarimu! Jarak berkurang {gerak_killer}m.")
        
        else:
            print("Pilihan tidak valid!")

        # Cek kondisi menang/kalah
        if jarak_killer >= 30:
            print("\nSelamat! Kamu cukup jauh untuk membuka pintu dan KABUR!")
            break
        elif jarak_killer <= 0:
            print("\nOH TIDAK! Killer berhasil menangkapmu. Game Over.")
            break
            
        putaran += 1

mulai_permainan()
            
