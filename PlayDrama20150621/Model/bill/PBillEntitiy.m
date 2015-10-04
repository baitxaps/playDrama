//
//  PBillEntitiy.m
//  PlayDrama
//
//  Created by hairong.chen on 15/7/20.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import "PBillEntitiy.h"

@implementation PBillEntitiy

#define max_nodes 200

struct tree{
    int         data;
    struct tree *lch;
    struct tree *rch;
};

int radiu;

int depth(struct tree *bt)
{
    int depl,depr;
    if (bt ==NULL) {
        return 0;
    }else{
        depl = depth(bt->lch);
        depl = depth(bt->rch);
        if (depl >=depr) {
            return depl +1;
        }else{
            return depr +1;
        }
    }
}

void setnodes_2(struct tree *bst,int k)
{
    if (bst!=NULL) {
        setnodes_2(bst->lch, 2 *k);
        //nodesk2 =1;
        setnodes_2(bst->rch,2*k+1);
    }
}

void setnodes(struct tree *bst)
{
    int a,b, i,j,k,k1,k2 = 0,length;
    int scr_wide = 560,scr_height = 360,wide,height,tmp_wide,tmp_height,kk;
    length = a = depth(bst);
    tmp_wide = wide = (int)(scr_wide/(pow(2, (a-1)+1)));
    kk = (int)(wide/2);
    
    radiu = kk -6;
    if (radiu >20) {
        radiu = 20;
    }
    
    for (i = 0; i <length; i++) {
        k1= 1;
        j = pow(2, (a-1));
        a--;
        b = j;
        while (j >0) {
            if (i ==0) {
              //  nodesb0 = k++ *wide +40;
                
            }else{
//                if (b == j) {
//                    nodesb0= pow(2, i-1)*tmp_wide +kk +40;
//                }else{
//                    nodesb0 = nodes*b -10 +wide;//
//                }
//                nodesb1 = 400 -height;
//                
            }
        }
    }
}


@end
