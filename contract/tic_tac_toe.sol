// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TicTacToe {
    uint8 constant BOARD_SIZE = 3;

    uint8[BOARD_SIZE][BOARD_SIZE] board;
    uint8 lastPlayer;
    uint8 player;
    uint8 winner;
    uint8 bid;

    constructor() public {
        // Oyun tahtasını sıfırla
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            for (uint8 j = 0; j < BOARD_SIZE; j++) {
                board[i][j] = 0;
            }
        }

        // İlk hamleyi yapan oyuncuyu belirle
        lastPlayer = 1;

        // Şu anda kazanan yok
        winner = 0;
    }

    function startGame() public {
        // Oyun tahtasını sıfırla
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            for (uint8 j = 0; j < BOARD_SIZE; j++) {
                board[i][j] = 0;
            }
        }
    }

    function play(uint8 x, uint8 y) public {
        require(board[x][y] == 0, "Bu alan zaten dolu");
        require(winner == 0, "Oyun zaten bitti");

        board[x][y] = lastPlayer;

        // Sonraki oyuncuyu belirle
        lastPlayer = (lastPlayer == 1) ? 2 : 1;

        // Satır kazanma durumları
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            if (board[i][0] == board[i][1] && board[i][1] == board[i][2] && board[i][2] != 0) {
                winner = lastPlayer;
            }
        }

        // Sütun kazanma durumları
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            if (board[0][i] == board[1][i] && board[1][i] == board[2][i] && board[2][i] != 0) {
                winner = lastPlayer;
            }
        }

        // Çapraz kazanma durumları
        if ((board[0][0] == board[1][1] && board[1][1] == board[2][2] && board[2][2] != 0) ||
            (board[0][2] == board[1][1] && board[1][1] == board[2][0] && board[2][0] != 0)) {
            winner = lastPlayer;
        }
    }

       function getBoard() public view returns (uint8[BOARD_SIZE][BOARD_SIZE] memory) {
        return board;
    }

    function move(uint8 x, uint8 y) public payable {
        require(winner == 0, "Oyun bitti.");
        require(x >= 0 && x < BOARD_SIZE, "X pozisyonu gecersiz.");
        require(y >= 0 && y < BOARD_SIZE, "Y pozisyonu gecersiz.");
        require(board[x][y] == 0, "Bu kare dolu.");
        require(lastPlayer == player, "Bu siradaki oyuncu siz degilsiniz.");
        require(msg.value == bid, "Yeterli odeme yapilmamis.");

        board[x][y] = lastPlayer;
        player = player == 1 ? 2 : 1;
        lastPlayer = lastPlayer == 1 ? 2 : 1;

        checkForWin();
    }

    function checkForWin() private {
        uint8 winLineLength = BOARD_SIZE;
        // Satırlar
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            uint8 counts = 0;
            for (uint8 j = 0; j < BOARD_SIZE; j++) {
                if (board[i][j] == lastPlayer) {
                    counts++;
                }
            }
            if (counts == winLineLength) {
                winner = lastPlayer;
            }
        }

        // Sütunlar
        for (uint8 j = 0; j < BOARD_SIZE; j++) {
            uint8 countx = 0;
            for (uint8 i = 0; i < BOARD_SIZE; i++) {
                if (board[i][j] == lastPlayer) {
                    countx++;
                }
            }
            if (countx == winLineLength) {
                winner = lastPlayer;
            }
        }

        // Çaprazlar
        uint8 count = 0;
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            if (board[i][i] == lastPlayer) {
                count++;
            }
        }
        if (count == winLineLength) {
            winner = lastPlayer;
        }

        count = 0;
        for (uint8 i = 0; i < BOARD_SIZE; i++) {
            if (board[i][BOARD_SIZE - i - 1] == lastPlayer) {
                count++;
            }
        }
        if (count == winLineLength) {
            winner = lastPlayer;
        }
    }

    function winnerPlayer() public view returns(uint){
        // 0 == kazanan yok & 2 == ilk oyuncu kazandi & 1 == 2. oyuncu kazandi

        return winner;

    }
}
