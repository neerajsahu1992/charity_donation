;; Charity Donation Tracker
;; Track donations to charities on-chain with transparency

(define-constant err-invalid-amount (err u100))
(define-constant err-not-owner (err u101))

;; Contract owner (charity admin)
(define-constant owner tx-sender)

;; Map donor principal to total donated amount
(define-map donations principal uint)

;; Total donations collected
(define-data-var total-donations uint u0)

;; Record a donation (anyone can call, amount passed in function)
(define-public (donate (amount uint))
  (begin
    (asserts! (> amount u0) err-invalid-amount)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender))) ;; Contract receives STX from sender
    (map-set donations tx-sender (+ (default-to u0 (map-get? donations tx-sender)) amount))
    (var-set total-donations (+ (var-get total-donations) amount))
    (ok true)
  )
)

;; Get total donations by a donor
(define-read-only (get-donations (donor principal))
  (ok (default-to u0 (map-get? donations donor)))
)
