;; Maintenance Log Contract
;; Tracks service history and repairs

(define-map records
  { id: uint }
  {
    vin: (string-ascii 17),
    service: (string-ascii 20),
    mileage: uint,
    provider: principal
  }
)

(define-data-var last-id uint u0)

;; Add a maintenance record
(define-public (add-record
              (vin (string-ascii 17))
              (service (string-ascii 20))
              (mileage uint))
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    ;; Update record counter
    (var-set last-id new-id)

    ;; Create the maintenance record
    (ok (map-set records
      { id: new-id }
      {
        vin: vin,
        service: service,
        mileage: mileage,
        provider: tx-sender
      }
    ))
  )
)

;; Get maintenance record
(define-read-only (get-record (id uint))
  (map-get? records { id: id })
)

;; Get total records count
(define-read-only (get-total-records)
  (var-get last-id)
)

