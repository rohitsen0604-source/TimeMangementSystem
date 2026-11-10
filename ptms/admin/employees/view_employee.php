<?php
require_once('./../../config.php');
if(isset($_GET['id'])){
    $qry = $conn->query("SELECT *,CONCAT(firstname,' ',middlename,' ', lastname) as fullname FROM `employee_list` where id = '{$_GET['id']}'");
    if($qry->num_rows > 0){
        $res = $qry->fetch_array();
        foreach($res as $k => $v){
            if(!is_numeric($k))
            $$k = $v;
        }
    }
}
?>
<style>
    #uni_modal .modal-footer{
        display:none;
    }
    #employee-img{
        height:200px;
        width:200px;
        object-fit: cover;
        object-position:center center;
    }
</style>
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-auto">
            <img src="<?= validate_image(isset($avatar) ? $avatar : "") ?>" alt="Employee Image" class="img-circle border bg-gradient-dark" id="employee-img">
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <dl>
                <dt class="text-muted">Employee Code</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($code) ? $code : 'N/A' ?></dd>
                <dt class="text-muted">Employee Name</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($fullname) ? $fullname : 'N/A' ?></dd>
                <dt class="text-muted">Gender</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($gender) ? $gender : 'N/A' ?></dd>
                <dt class="text-muted">Email</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($email) ? $email : 'N/A' ?></dd>
            </dl>
        </div>
        <div class="col-md-6">
            <dl>
                <dt class="text-muted">Department</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($department) ? $department : 'N/A' ?></dd>
                <dt class="text-muted">Position</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($position) ? $position : 'N/A' ?></dd>
                <?php if(!empty($generated_password)): ?>
                <dt class="text-muted">Generated Password</dt>
                <dd class='pl-4 fs-4 fw-bold'><?= isset($generated_password) ? $generated_password : 'N/A' ?></dd>
                <?php endif; ?>
                <dt class="text-muted">Status</dt>
                <dd class='pl-4 fs-4 fw-bold'>
                    <?php 
                        switch ($status){
                            case 1:
                                echo '<span class="rounded-pill badge badge-success bg-gradient-teal px-3">Active</span>';
                                break;
                            case 0:
                                echo '<span class="rounded-pill badge badge-danger bg-gradient-danger px-3">Inactive</span>';
                                break;
                        }
                    ?>
                </dd>
            </dl>
        </div>
    </div>
    <div class="text-right">
        <button class="btn btn-flat btn-dark btn-sm" type="button" data-dismiss="modal"><i class="fa fa-times"></i> Close</button>
    </div>
</div>
